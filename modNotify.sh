# The default notification system is too "subtle". I always miss it and looked around and found this here:
# http://askubuntu.com/questions/128474/how-to-customize-on-screen-notifications
# Save it as a script, and run it the usual way of "bash modNotify.sh"

# Settings I like, so it catches my eye.
# Behavior
#   Positioning:       Dynamic
#   Location:          Middle Left
# Bubble
#   Background Colour: Dark green
# Text   
#   Text Title Colour: Custom (gray)
#   Text Body Colour:  Light Grey

sudo add-apt-repository ppa:leolik/leolik 
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install libnotify-bin
pkill notify-osd
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt-get update
sudo apt-get install notifyosdconfig
