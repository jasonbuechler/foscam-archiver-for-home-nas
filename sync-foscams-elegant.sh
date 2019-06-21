#!/bin/sh
# 
# This single script can be used for simple mirror operations
#  ...as opposed to complex Lftp scripting.
#
# It's easier to use than the minimal .sh script, but harder to read or to
# customize. You'll need to mod this yourself for httpS or funky passwords.
#

adds="192.168.1.101:88  192.168.1.102:88  192.168.1.103:88"
usrs="USERNAME1         USERNAME2         USERNAME3"
pwds="PASSWORD1         PASSWORD2         PASSWORD3"
dirs="/media/cam1       /media/cam2       /media/cam3"

##  Fill out the 4 lines above  ##
##  with one entry per camera.  ##
##################################


i=1
# loop from 1 to the # of "words" in $adds
while [ $i -le $(echo $adds | wc -w) ]
do
  # assign the i'th "word" of each "array" to a var
  add=$(echo $adds | awk "{print \$$i}")
  usr=$(echo $usrs | awk "{print \$$i}")
  pwd=$(echo $pwds | awk "{print \$$i}")
  dir=$(echo $dirs | awk "{print \$$i}")

  # compile the ftp-wake-up url, and
  # split $add at ':' and set $ip to 1st chunk
  url="http://$add/cgi-bin/CGIProxy.fcgi?cmd=startFtpServer&usr=$usr&pwd=$pwd"
  ip=$(echo $add | cut -d : -f 1)

  echo curl -v \"$url\"
  curl -v "$url"

  echo lftp -u $usr,$pwd -e \"mirror -v / $dir\" -p 50021 ftp://$ip
  lftp -u $usr,$pwd -e "mirror -v / $dir" -p 50021 ftp://$ip

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
