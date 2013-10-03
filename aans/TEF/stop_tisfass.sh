#!/bin/sh
# module:         stop_tisfass.sh
# version:        1.1
# last modify:    95/11/22 12:54:59
#
# @(#)stop_tisfass.sh	1.1 95/11/22 12:54:59  
#
#
#set -x
TISFASS_LOCK=/tef/tmp/tisfass.lck
TISFASS_TEMP_LOCK=/tef/tmp/tisfass.tmp.lck
HOST=`hostname`
#
#

if [ -f $TISFASS_LOCK ]
then

    # read out the locking information
    read R_WINID R_USER R_HOST R_LISP_PID R_DATE < $TISFASS_LOCK
    # TISFASS can only run at one unique workstation.
    if [ $R_HOST = $HOST ]
    then
        kill -TERM $R_LISP_PID
        if [ $USER != root ]
        then
            rm -f $HOME/lisp-init.lisp
        fi
        rm -f $TISFASS_LOCK
        rm -f $TISFASS_TEMP_LOCK
        echo "TISFASS-Lisp interpreter (PID=$R_LISP_PID) terminated."
    else
        echo "TISFASS active but not running on $HOST."
    fi
else
    echo "TISFASS not running: no need to terminate."
fi
exit 0
