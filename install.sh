#!/bin/bash
# Install pibutton

basedir=/usr/local/pibutton

#update system
apt-get update
apt-get upgrade -y
apt-get install -y hostapd dnsmasq vim ssmtp mailutils mpack
echo "All required software has been installed." && sleep 2

#copy pibutton directory
cp -rfp pibutton /usr/local/
echo "Copied pibutton to /usr/local/pibutton." && sleep 2

chmod -R 750 $basedir
chown -R root:root $basedir
echo "Set permissions on /usr/local/pibutton." && sleep 2

#replace key system files

#hostapd.conf
cp $basedir/configs/hostapd.conf /etc/hostapd/hostapd.conf
echo "Replaced /etc/hostapd/hostapd.conf." && sleep 2

#hostapd
cp $basedir/configs/hostapd /etc/default/hostapd
update-rc.d hostapd enable
echo "Replace /etc/default/hostapd." && sleep 2

#dnsmasq.conf
cp $basedir/configs/dnsmasq.conf /etc/dnsmasq.conf
echo "Replaced /etc/dnsmasq.conf." && sleep 2

#ssmtp.conf
cp $basedir/configs/ssmtp.conf /etc/ssmtp/ssmtp.conf
echo "Replaced /etc/ssmtp/ssmtp.conf." && sleep 2

#pibutton into /usr/local/bin
cp $basedir/scripts/pibutton /usr/local/bin/pibutton
echo "Installed /usr/local/bin/pibutton." && sleep 2

#interfaces
cp $basedir/configs/interfaces /etc/network/interfaces
echo "Installed /etc/network/interfaces." && sleep 2

#change hostname
cat $basedir/configs/hosts > /etc/hosts
echo "pibutton" > /etc/hostname

#setup daily status cronjob
echo "0 4 * * * /usr/local/pibutton/scripts/status.sh" > /var/spool/cron/crontabs/root

echo "Please run \"sudo pibutton\" to setup smtp settings before enabling dash buttons."
echo "Please reboot to complete installation." && sleep 2
