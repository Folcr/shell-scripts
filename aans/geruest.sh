#!/bin/sh 
# module:         %M%
# version:        %I%
# last modify:    %E% %U%
#
# %W% %E% %U% %Y% %Q%, Volker Braun.
#
#set -x
#exec >/tmp/$0.$$ 2>&1
#
MYNAME=`basename $0`
#
USAGE()
{
    echo "Usage:"
    echo
    echo "$MYNAME [old extension] [new extension]"
    echo
    echo "$MYNAME moves all files with the [old extension]" 
    echo "to files with identical basename with [new extension]." 
    echo "e.g.: $MYNAME doc ilf"
    echo "moves all ./*.doc files to ./*.ilf"
    echo
 
    exit 0
}
#
if [ $# != 2 ]
then
    USAGE
fi
#
