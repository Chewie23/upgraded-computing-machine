#!/bin/bash

#Made in Ubuntu 16.04 LTS, 64-bit. Pretty sure you can make this work in Cygwin for Windows, but worse comes to worse, translate into PowerShell/Python/C++/Golang

#This script auto locks screen every 30 minutes from bootup AND 30 minutes after you log back in after lockout
#To take a break from staring at a computer screen all day

#To put script into startup app: http://askubuntu.com/questions/48321/how-do-i-start-applications-automatically-on-login
#In command, do /path/to/script.sh (Ex. ~/breakTime.sh)
#Make sure the script is executable! Use "chmod +x /path/to/script"

#the command to lock screen: gnome-screensaver-command -l
#Perishable notification box: notify-send "Locking screen in 5 seconds!"

#To get logs for when last unlocked: tac /var/log/auth.log|grep -m1 "unlocked" (will reverse [tac] the log file, and only find the first line with instance of string)
#
#alternative way of getting this: journalctl -b 0 -r |grep -m1 "unlocked"
# 
#To only get the time: journalctl -b 0 -r |grep -m1 "unlocked" |awk '{print $3}'

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    #below is the information needed to make into a .desktop file.
    #This is only required if making the script into a startup app WITHOUT the GUI.
    #Highly recommended to use GUI, but if not, here is more info: http://askubuntu.com/questions/598195/how-to-add-a-script-to-startup-applications-from-the-command-line

    #You want the file extension to end in ".desktop" (Ex. breakTime.sh.desktop) when you put it in the appropriate place

    #[Desktop Entry]
    #Type=Application
    #Exec="~/UnixScript/breakTime.sh"
    #Hidden=false
    #NoDisplay=false
    #X-GNOME-Autostart-enabled=true
    #Name[en_IN]=BreakTime
    #Name=BreakTime
    #Comment[en_IN]=AnyComment
    #Comment=AnyComment
#---------------------------------------------------------------------------------------------------------------------------------------------------------------------

thirtyMinInSeconds="$((30*60))" #1800 (seconds).
oneMinInSeconds=60 

function notify_and_lock {
    sleep $((thirtyMinInSeconds - 5))
    notify-send "Locking screen in 5 seconds!"
    sleep 4
    gnome-screensaver-command -l
}

notify_and_lock

#below: will continuously check unlock time and compare with current time. 
#This is needed to "refresh" unlock time variable.
#Maybe slightly inefficient, but could not find an easy way of checking unlock time and lock time in a general fashion

#Strange behaviour: when you boot up for the first time, the command: "journalctl -b 0 |grep "unlocked" will NOT work in terminal. Don't know if this is a bug or not
while true
do
    isoUTC=$(journalctl -o short-iso -b 0 -r |grep -m1 "unlocked" |awk '{print $1}')
    #grabs the last time you unlocked the computer. Maybe have the original script go (w/o while loop) and then this

    unlockedTime=$(date -d "$isoUTC" +%s) #gets the Epoch time of unlock time of UTC        
    currentTime=$(date +%s)
    timeDifference=$((currentTime - unlockedTime)) #gives the difference in years, months, and days (in terms of seconds)
   
    if [ $timeDifference -eq $((oneMinInSeconds - 5)) ]
    then
        notify_and_lock
    fi
done
