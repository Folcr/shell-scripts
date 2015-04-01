#!/bin/bash
# $Id: dms-release.sh 59 2012-12-19 12:22:38Z Volker Braun $
# DMS release script for a document
# $1 is the document to be released
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
echo "about to release $1"
svn info $DOC >> $DEBUG
#
DOCID=`svn propget $DMSDOCID $DOC`
if [ -z "$DOCID" ]
then
	echo "ABORT: Document-ID not set on: \"$DOC\"."
	exit 1
fi
# set state to reviewed
svn propset "dms:state" "reviewed" $DOC
#set the reviewer's name
svn propset "dms:reviewer" "$USER" $DOC
# set the file to needs-lock, read-only
svn propset "svn:needs-lock" TRUE $DOC
#
svn proplist $DOC >> $DEBUG
svn diff $DOC >> $DEBUG
#
echo "checking in modifications"
svn commit $DOC -m "${DOC} with Doc-ID=${DOCID} released by ${USER}@${COMPUTERNAME}."
#on Windows: open debug file in editor
notepad.exe "C:\\Temp\\$TEMPFILE" &
exit 0
#EOF