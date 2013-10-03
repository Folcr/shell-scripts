#!/bin/sh
# module:         lisp.sh
# version:        1.1
# last modify:    95/04/28 14:48:01
#
# @(#)lisp.sh	1.1 95/04/28 14:48:01  
#
#
set -x
LISP=/tef/iabg/itc/lisp4.1/non-dbcs/lisp;
DISPLAY=:0.1;export DISPLAY
$LISP </dev/console >/dev/console 2>/dev/console
# after exit of TISFASS remove the Lock files.
rm -f $HOME/lisp-init.lisp
rm -f $TISFASS_LOCK
exit

