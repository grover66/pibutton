### PiButton:
PiButton, used with a Raspberry Pi 3 (or Raspberry Pi 2 + Wireless Dongle), will allow you to control IFTTT enabled services using a $5 Dash Button.

#### Uses include:
* Parental Panic Button (I've fallen and I can't get up).
* IFTTT compatable devices (Lights, Garage Doors, Alarm Systems, etc.)

#### How it works:
* Existing services to work with Dash Buttons are based on packet sniffers. They watch for the Dash Button to broadcast its MAC address, which triggers a REST call to the Maker channel on IFTTT.com The problem with this solution is you need the right network and a wireless NIC that is capable of "Monitor Mode". Also, your script may be executed multiple times depending on how many times the Dash Button's MAC shows up on the wire. Long story short, It's complicated.  
* I setup a seperate hidden wireless network using a drop dead simple hook in dnsmasq which executes a script whenever a new device connects. Since the only devices that know about this network are the Dash Buttons, it works everytime without issue.
* The install.sh script does the following;
** Updates raspian repos.
** Upgrades all packages.
** Installs all required software, including hostapd, dnsmasq and ssmtp.
** 
