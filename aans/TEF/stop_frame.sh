#!/bin/sh
# module:         stop_frame.sh
# version:        1.7
# last modify:    95/11/22 11:51:24
#
# @(#)stop_frame.sh	1.7 95/11/22 11:51:24  
#
# Script zum Beenden von Framemaker/viewer.
# set -x

if [ x$SCREEN_RIGHT = x ]
then
    SCREEN_RIGHT=0
fi

echo  send remote terminate to frameviewer
/tef/bin/docclient -display :0.$SCREEN_RIGHT >/dev/null <<_EOF
x
q!
_EOF

# if Framemaker is not running, docclient will time out after a time and exit.

exit 0

