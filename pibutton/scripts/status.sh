#!/bin/bash
# Send system status email (weekly by default).
# Change status email cronjob by typing crontab -e (as root).

#status email address:

EMAIL=root@localhost
SUBJECT="Your PiButton system is working normally."
echo "HOSTNAME: "`hostname` > /tmp/message.txt
echo "UPTIME: "`uptime` >> /tmp/message.txt
echo "IP Address Info:" >> /tmp/message.txt
/sbin/ifconfig >> /tmp/message.txt

cat /tmp/message.txt | mail -s "$SUBJECT" $EMAIL
