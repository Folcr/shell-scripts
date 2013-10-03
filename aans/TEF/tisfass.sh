#!/bin/sh
# module:         tisfass.sh
# version:        1.3
# last modify:    95/05/24 14:46:36
#
# @(#)tisfass.sh	1.3 95/05/24 14:46:36  
#
set -x
TISFASS_SCRIPT=/tef/iabg/itc/tisfass-init.lisp
LISP_SCRIPT=/tef/bin/lisp.sh
TISFASS_LOCK=/tef/tmp/tisfass.lck;export TISFASS_LOCK
TISFASS_TEMP_LOCK=/tef/tmp/tisfass.tmp.lck
WININFOPROG='/X/bin/xwininfo -display :0.1 -root -tree'
DIALOGCMD=/tef/bin/dialogcmd
DEICONIFY=/tef/bin/deiconify
HOST=`hostname`
#
#
if [ -f $TISFASS_TEMP_LOCK ]
then
    # TISFASSS is initializing: refuse all
    echo"TISFASS is initializing - stand by"
    $DIALOGCMD sav general_s_msg "TISFASS not ready"
    exit
fi

if [ -f $TISFASS_LOCK ]
then
    # read out the locking information
    read R_WINID R_USER R_HOST R_DATE < $TISFASS_LOCK
    # user AND host is a uniqe key, so TISFASS is ours.
    if [ $R_USER = $USER -a $R_HOST = $HOST ]
    then
        if [ $R_WINID = nowinid ]
        then
            echo "Cannot expose TISFASS - unknown window-ID"
            $DIALOGCMD sav general_s_msg "Cannot expose TISFASS"
        else
            $DEICONIFY $R_WINID
        fi
    else
        echo "TISFASS is locked for $R_USER on $R_HOST"
        $DIALOGCMD sav general_s_msg "TISFASS lock $R_USER/$R_HOST"
    fi
else
    $DIALOGCMD sav general_s_msg "starting TISFASS..."
    touch $TISFASS_TEMP_LOCK
    ln -s $TISFASS_SCRIPT $HOME/lisp-init.lisp
    # start lisp in the background
    $LISP_SCRIPT&
    
    
    timer_count=0
    while
        # wait until TISFASS has been loaded and try again
        $WININFOPROG  | grep TISFASS > /tmp/winid.$$
        read WINID etc < /tmp/winid.$$
        rm -f /tmp/winid.$$
        [ x$WINID = x ]
    do
        # verify that lisp is still running
        LISPTEST=`ps -ax | grep lisp.sh | grep -v grep`
        if [ "x$LISPTEST" = x ]
        then
            # lisp is not running any more: Error?.
            rm -f $HOME/lisp-init.lisp
            rm -f $TISFASS_LOCK
            rm -f $TISFASS_TEMP_LOCK
            exit
        fi
        timer_count=`expr $timer_count + 1`
        if [ $timer_count -ge 50 ]
        then
            echo "tisfass script timed out!"
            WINID="nowinid"
        fi
    done
        
    DATE=`date +%a/%d/%m/%y,%T`
    echo "$WINID $USER $HOST $DATE" >$TISFASS_LOCK
    # make sure the world can read our lock file
    chmod 666 $TISFASS_LOCK
    rm -f $TISFASS_TEMP_LOCK
    $DIALOGCMD sav general_s_msg "TISFASS started."
fi
exit
