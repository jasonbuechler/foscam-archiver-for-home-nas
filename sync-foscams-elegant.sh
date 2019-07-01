#!/bin/sh
# 
# This single script can be used for simple mirror operations
#  ...as opposed to complex Lftp scripting.
#
# It's easier to use than the minimal .sh script, but harder to read or to
# customize. You'll need to mod this yourself for httpS or funky passwords.
#

ADDS="192.168.1.101:88  192.168.1.102:88  192.168.1.103:88"
USRS="USERNAME1         USERNAME2         USERNAME3"
PWDS="PASSWORD1         PASSWORD2         PASSWORD3"
DIRS="/media/cam1       /media/cam2       /media/cam3"

##  Fill out the 4 lines above  ##
##  with one entry per camera.  ##
##################################


i=1
# loop from 1 to the # of "words" in $ADDS
while [ $i -le $(echo $ADDS | wc -w) ]
do
  # assign the i'th "word" of each "array" to a var
  # (elements are cut at whitespace so... beware)
  ADD=$(echo $ADDS | cut -w -f $i)
  USR=$(echo $USRS | cut -w -f $i)
  PWD=$(echo $PWDS | cut -w -f $i)
  DIR=$(echo $DIRS | cut -w -f $i)

  # compile the ftp-wake-up url, and
  # split $ADD at ':' and set $ip to 1st chunk
  url="http://$ADD/cgi-bin/CGIProxy.fcgi?cmd=startFtpServer&usr=$USR&pwd=$PWD"
  ip=$(echo $ADD | cut -d : -f 1)

  echo curl -v \"$url\"
  curl -v "$url"

  echo lftp -u $USR,$PWD -e \"mirror -v / $DIR\" -p 50021 ftp://$ip
  lftp -u $USR,$PWD -e "mirror -v / $DIR" -p 50021 ftp://$ip

  i=`expr $i + 1`
done


#=================================================================================
#
# full url to call (with curl) to start ftp server...
# eg: http://192.168.1.101:88/cgi-bin/CGIProxy.fcgi?cmd=startFtpServer&usr=ME&pwd=MYPASS
#
# Lftp string to locally archive...
# eg: lftp -u ME,MYPASS -e "[mirror command]" -p 50021 ftp://192.168.1.101
#
# mirror command string to feed lftp (requires quotes)...
# eg: mirror -v / /root/media/cam101
#               | |
#               | \-- local system target path (e.g. writeable storage)
#               \---- remote system source path (e.g. camera FTP root)
#
#
# Cameras will *not* mirror simultaneously unless the 'lftp' line has a
# trailing ampersand (&) to force it into the background.
#
#=================================================================================
