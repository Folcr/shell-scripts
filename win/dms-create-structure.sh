#!/bin/bash
# $Id:$
# start this script at an emtpy container directory
# this script checks out the upper levvel directory structure
#
# start configuration section
MYSELF=`basename "$0"`
CTEMP="/cygdrive/c/Temp"
REPO="http://dms/dms"
# needed paths, space seperated
NEED="90_QM/Dokumentenmanagementsystem 80_Office/Vorlagen"
# end configuration section
TRUNK="${REPO}/trunk"
DATE=`date +%Y-%m-%dT%H%M%S`
TEMPFILE="${DATE}_$MYSELF.txt"
DEBUG="$CTEMP/$TEMPFILE"
# 
echo "creating DMS structure in this directory [y/n]?"
read answer
if [ $answer != "y" ]
then
	exit 1
fi
# start
mkdir DMS
cd DMS
#
svn co ${REPO} ./ --depth immediates
cd trunk
svn co ${TRUNK} ./ --depth immediates
for i in *
do
	cd $i
	svn co ${TRUNK}/$i ./ --depth immediates
	cd ..
done
# pwd == trunk
# checkout needed paths infinite depth
for n in $NEED
do
	svn co ${TRUNK}/$n $n --depth infinity
done
exit 0
#EOF