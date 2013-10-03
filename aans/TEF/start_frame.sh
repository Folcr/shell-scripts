#!/bin/sh
# module:         start_frame.sh
# version:        1.7
# last modify:    95/06/19 15:43:34
#
# @(#)start_frame.sh	1.7 95/06/19 15:43:34  
#
#
if [ x$SCREEN_RIGHT = x ]
then
    SCREEN_RIGHT=0
fi

WININFOPROG="/X/bin/xwininfo -display :0.$SCREEN_RIGHT -root -tree"
# WININFOPROG shall output lines like this (first field is window-ID):
# '0x140001d (has no name): ()  10x10+-100+-100  +-100+-100'
#
#set -x
HELPPATH='/tef/lib/help'
# vb: FMHELPDOC is the Startup document for the extended Help function
FMHELPDOC='TEFhelp.doc'
# if there are any Frame-Lock-files, remove them!
for i in $HELPPATH/*.lck
do
    rm -f $i
done
#
case $HOST in
        tefap1)  FMPROG="imakergerman -display :0.$SCREEN_RIGHT"
            ;;
        *)       FMPROG="viewer -display :0.$SCREEN_RIGHT"
            ;;
esac
xrdb -merge /tef/lib/X11/app-defaults/Maker
echo "starting $FMPROG at `date`"
su nobody -c "$FMHOME/bin/bin.sun4/$FMPROG -f $HELPPATH/$FMHELPDOC" &
#
# Feststellen der window-ID des geladenen FMHELPDOC
# um das window zu ikonifizieren.
timer_count=0
while
    $WININFOPROG  | grep $FMHELPDOC > /tmp/winid.$$
    read WINID etc < /tmp/winid.$$
    rm -f /tmp/winid.$$
    [ x$WINID = x ]
do
# wait until FMHELPDOC has been loaded and try again
    sleep 1
    timer_count=`expr $timer_count + 1`
    if [ $timer_count -ge 20 ]
    then
        echo "start_frame timed out at `date`!"
        exit
    fi
done
#
/tef/bin/iconify $WINID 
echo "iconify Framewindow: $WINID at `date`"          
#
#
exit 0
