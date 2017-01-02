#!/bin/bash
# pibutton cli

#variables
basedir=/usr/local/pibutton
scriptdir=/usr/local/pibutton/scripts

#subroutines

register_button() {

	$scriptdir/pibutton_enable_firewall.sh
	echo "---"

	echo "Step 1:"
	echo "Run the Amazon Shopping App on your Phone."
	sleep 1
	read -p "Press [Enter] to continue." X
	echo

	echo "Step 2:"
	echo "Touch \"Your Account\"."
	sleep 1
	read -p "Press [Enter] to continue." X
	echo

	echo "Step 3:"
	echo "Under Dash Devices, touch \"Set up a new device\"."
	sleep 1
	read -p "Press [Enter] to continue." X
	echo

	#make ssid visible
	sed -i "/^ignore_broadcast_ssid/c\ignore_broadcast_ssid=0" /etc/hostapd/hostapd.conf
	/usr/sbin/service hostapd reload

	echo "Step 4:"
	echo "Choose Dash Button."
	echo
	echo "Follow the app instructions, ONLY completing the wifi settings (using the following info)."
	echo
	echo "Network: pibutton"
	echo "Password: raspberry"
	echo
	echo "Do NOT choose a product when prompted. Exit out and close the app."
	sleep 1
	read -p "Press [Enter] to continue." X
	echo

	echo "###" > /var/log/pibuttons
	$scriptdir/pibutton_disable_firewall.sh

	#make ssid hidden
	sed -i "/^ignore_broadcast_ssid/c\ignore_broadcast_ssid=1" /etc/hostapd/hostapd.conf
	/usr/sbin/service hostapd reload

	echo "Step 5:"
	echo "Press the Dash Button to register MAC address."
	echo
	echo -n "Waiting for new button to be detected..."
	for I in `seq 1 60`; do
		L=`cat /var/log/pibuttons | wc -l`
		echo -n "."
		if [ $L -ge 2 ]; then
			echo
			MAC=`cat /var/log/pibuttons | grep -v "^#" | awk '{ print $3 }'`
			echo "$MAC  email  root@localhost  1" >> /usr/local/pibutton/button_table
			echo "Done."
			sleep 2
			return
		fi
	sleep 1
	done
	echo "No Dash button was detected."
	echo "Done."
	sleep 3
}

edit_button_table() {
	echo
	read -p "Press [Enter] to edit $basedir/button_table using Nano text editor." X
	nano $basedir/button_table
	sleep 1
}

edit_email_header() {
	read -e -p "Which header file do you wish to edit (default=1)? " -i "1" H
	read -p "Press [enter] to edit $basedir/header_$H.txt using Nano text editor." X
	nano $basedir/header_$H.txt
	sleep 1
}

edit_email_message() {
	read -e -p "Which message file do you wish to edit (default=1)? " -i "1" M
	read -p "Press [enter] to edit $basedir/message_$M.txt using Nano text editor." X
	nano $basedir/message_$M.txt
	sleep 1
}

edit_status_email() {
	echo
	OSE=`grep ^EMAIL $scriptdir/status.sh | cut -d\= -f2`
	read -e -p "Send system status emails to: " -i $OSE SSE
	sed -i "/^EMAIL/c\EMAIL=$SSE" $scriptdir/status.sh
	sleep 1
	echo "Done."
	sleep 1
}

edit_smtp_settings() {
        echo
	echo "Please modify the following lines to get email working with your PiButton;"
	echo "mailhub=your.smtp.server"
	echo "AuthUser=email_address"
	echo "AuthPass=email_password"
	echo
	read -p "Press [enter] to edit /etc/ssmtp/ssmtp.conf with your smtp info." X
	nano /etc/ssmtp/ssmtp.conf
	sleep 1
}

reboot_shutdown() {
	read -p "(r)eboot or (s)hutdown? " A
	if [ "$A" == "r" ]; then
		echo "Rebooting..."
		sleep 2
		/sbin/shutdown -r now
	elif [ "$A" == "s" ]; then
		echo "Shutting down now..."
        	sleep 2
		/sbin/shutdown -h now
	fi
}

#code

#menu
main_menu() {
clear
echo "Pi Button Setup Menu."
echo "------------------------------------"
echo "### Dash Buttons ###" 
echo "1) Register a Dash Button."
echo "2) Edit Button Table."
echo
echo "### Email Setup ###"
echo "3) SMTP Setting"
echo "4) Edit Email Header."
echo "5) Edit Email Message."
echo
echo "### System Status Emails ###"
echo "6) Edit System Status Email Info."
echo
echo "### Misc ###"
echo "7) Reboot/Shutdown."
echo "8) Quit."
echo "---"
read -p "Choose: " Q

if [ "$Q" == "1" ]; then
	register_button

elif [ "$Q" == "2" ]; then
        edit_button_table

elif [ "$Q" == "3" ]; then
        edit_smtp_settings

elif [ "$Q" == "4" ]; then
        edit_email_header

elif [ "$Q" == "5" ]; then
        edit_email_message

elif [ "$Q" == "6" ]; then
        edit_status_email

elif [ "$Q" == "7" ]; then
        reboot_shutdown

elif [ "$Q" == "8" ]; then
        exit 0
fi
main_menu
}

#code
main_menu
exit 0
