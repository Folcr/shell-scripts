#!/bin/bash
# $Id: dms-put-docid.sh 59 2012-12-19 12:22:38Z Volker Braun $
# DMS label document ID script for a document
# $1 is the document to be labeled with a new doc ID
# the doc ID is received from the document ID generator
#
# start configuration section
MYSELF=`basename "$0"`
DOC="$1"
DMSDOCID="dms:DocId"
CTEMP="/cygdrive/c/Temp"
# end configuration section
DATE=`date +%Y-%m-%dT%H%M%S`
TEMPFILE="${DATE}_$MYSELF.txt"
DEBUG="$CTEMP/$TEMPFILE"
# 
touch $DEBUG
#
# obtain a document id from a web service
DOCID=`wget -qO- http://svn01/docidgen/`
#
echo "about to write Doc-ID \"$DOCID\" to $DOC"
svn info $DOC >> $DEBUG
# set state to reviewed
svn propset $DMSDOCID "$DOCID" $DOC
#
svn proplist $DOC >> $DEBUG
svn diff $DOC >> $DEBUG
#
#echo "checking in modifications"
#svn commit $DOC -m "${DOC} with Doc-ID=${DOCID} released by ${USER}@${COMPUTERNAME}."
#on Windows: open debug file in editor
notepad.exe "C:\\Temp\\$TEMPFILE" &
exit 0
#EOF