#!/bin/sh
# module:         airsituation.sh
# version:        1.1
# last modify:    95/04/28 14:48:00
#
# @(#)airsituation.sh	1.1 95/04/28 14:48:00  
#
#
set -x
TISFASS_LOCK=/tef/tmp/tisfass.lck;
DIALOGCMD=/tef/bin/dialogcmd
ICONIFY=/tef/bin/iconify
HOST=`hostname`

if [ -f $TISFASS_LOCK ]
then
    # read out the locking information
    read R_WINID R_USER R_HOST R_DATE < $TISFASS_LOCK
    # user AND host is a uniqe key, so TISFASS is ours.
    if [ $R_USER = $USER -a $R_HOST = $HOST ]
    then
        if [ $R_WINID = nowinid ]
        then
            echo "Cannot iconify TISFASS - unknown window-ID"
            $DIALOGCMD sav general_s_msg "Cannot iconify TISFASS"
        else
            $ICONIFY $R_WINID
        fi
    fi
fi
exit
