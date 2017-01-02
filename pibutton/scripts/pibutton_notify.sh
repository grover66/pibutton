#!/bin/bash

#debug
echo `date +%Y/%m/%d@%H:%m`" $@" >> /var/log/pibuttons

#notify script

#variables
basedir=/usr/local/pibutton
scriptdir=/usr/local/pibutton/scripts

#subroutines

restcall() {
   curl -X POST $V
}

email() {
   cat $basedir/message_$N.txt | mail -s "`cat $basedir/header_$N.txt`" $V
}

#code
if [ "$1" == "del" ]; then
        exit 0
else
        grep -q "$2" $basedir/button_table
        if [ "$?" == "0" ]; then
                M=$2
                grep "$M" $basedir/button_table | awk '{ print $2" "$3" "$4 }' > /tmp/pibutton_send_list
                while read LINE; do
                        C=`echo $LINE | awk '{ print $1 }'`
                        V=`echo $LINE | awk '{ print $2 }'`
                        [ "$C" == "email" ] && N=`echo $LINE | awk '{ print $3 }'`
                        [ "$C" == "curl" ] && restcall 
                        [ "$C" == "email" ] && email
                done < /tmp/pibutton_send_list
        fi
fi
