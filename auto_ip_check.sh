# IP checker and mailer
#it does what it says, if you are like me and you are too cheap to buy a static IP address from your ISP but you want to know whenever your WAN IP changes, you can use this on a linux box that is powered all the time! Take that Comcast!
#written by 4n0m4l0u5 in linux mint 17.3


#create a new folder where you want to store this script, you will need to remember where you put this... for example /home/USERNAME/Documents/IP_Check
#be sure to put this file in the IP_Check folder you created


#********SETUP********

#enter your email address here inside the quotes:
E_ADDR="xxxxxx@gmail.com"

#this is the variable that contains the path to the ip.txt file, change /home/USERNAME/Documents/IP_Check/ip.txt to the actual path, where ever you decided to put it...
FILE="/home/USERNAME/Documents/IP_Check/ip.txt"

#******END SETUP******


#to set up postfix (etc/postfix/main.cf and etc/postfix/sasl_passwd) for gmail, go to https://rtcamp.com/tutorials/linux/ubuntu-postfix-gmail-smtp/ or you can use this installation summary:

#install these packages:
#sudo apt-get install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules
#choose "internet" (SMTP) mail service and use default FQDN

#for gmail (or if you have something other than gmail you have to figure out what they use), add these lines to /etc/postfix/main.cf... also, if you have two step verification, you will have to generate an app password in gmail and use it here:
#relayhost = [smtp.gmail.com]:587
#smtp_sasl_auth_enable = yes
#smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
#smtp_sasl_security_options = noanonymous
#smtp_tls_CAfile = /etc/postfix/cacert.pem
#smtp_use_tls = yes

#open/create file: /etc/postfix/sasl_passwd
#enter your info like so:[smtp.gmail.com]:587    USERNAME@gmail.com:PASSWORD
#save and change permissions with this code:
#sudo chmod 400 /etc/postfix/sasl_passwd
#sudo postmap /etc/postfix/sasl_passwd

#validate certificates by running this code:
#cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | sudo tee -a /etc/postfix/cacert.pem
#you may need to look these certificates up and install them manually if your disro does not come with them pre installed (linux mint 18 for example)

#then reload postfix:
#sudo /etc/init.d/postfix reload

#add this file to cron jobs, example for every hour, on the hour:
#crontab -e
#append this line to run once every hour:
#0 * * * * /home/USERNAME/Documents/IP_Check/auto_ip_check.sh
#again, be sure to use the actual path you chose above and/or replace USERNAME with your actual...


#IP checker and mailer...

#check wan ip address and store it into this variable (not your local IP)
IP_ADD_NEW=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')


if [ -f "$FILE" ]   #check to see if the ip.txt file exists...

then    #if it does exist, check the old contents with the newly returned IP address to see if they are different
	IP_ADD_OLD=$(cat "$FILE")       #read contents of ip.txt into a variable
	if [ $IP_ADD_OLD != $IP_ADD_NEW ]       #check and see if the IP address changed
	then
		echo "$IP_ADD_NEW" | mail -s "IP Address change" $E_ADDR    #if it changed, mail out the new one
		echo "$IP_ADD_NEW" > $FILE  #save new IP address to file
	fi

else    #if it doesnt exist then send out first time notification
	echo "$IP_ADD_NEW" > $FILE  #save new IP address to file
	echo "$IP_ADD_NEW" | mail -s "NEW IP Address" $E_ADDR   #mail out the new one
fi

#done!
