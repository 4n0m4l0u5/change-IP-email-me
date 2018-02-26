# change-IP-email-me
Linux script that automatically sends an email when your WAN IP address changes, usually is default setup by your ISP. I use this to keep track of my IP in case I'm away from home and the off chance that my IP address changed, I know where home is... Take that ISP's.
Setup for Ubuntu 16.04, most debian distros should work though. You may need additioinal packages, keep an eye out in your terminal.

#setup - clone repo
# in a terminal (ctl + alt + t) run the following commands:
git clone https://github.com/4n0m4l0u5/change-IP-email-me.git

#setup - make changes to auto setup file to suit your needs, directions are in the file itself
nano auto_ip_check.sh
#make your changes and save

or if you're oldschool, you can use vi
vi auto_ip_check.sh
#make your changes and save

#setup -make file executable and run
chmod +x auto_ip_check.sh
./auto_ip_check.sh

#make sure it works and you're all done
#check systemlogs for any errors if it is not working
