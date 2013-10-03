#!/bin/sh
# module:         iconify.sh
# version:        1.1
# last modify:    95/11/22 12:01:31
#
# @(#)iconify.sh	1.1 95/11/22 12:01:31  
#
# 1. Parameter: Fensternamen des zu ikonofizierenden Fensters
#set -x

WININFOPROG='/X/bin/xwininfo -root -tree'
ICONIFY=/tef/bin/iconify
#
$WININFOPROG  | grep $1 > /tmp/winid.$$
read WINID etc < /tmp/winid.$$
rm -f /tmp/winid.$$
if [ x$WINID = x ]
then 
    exit
else
    $ICONIFY $WINID
    echo "$0: iconified window $WINID at `date`"
fi
exit
