#!/bin/sh
#
# This single script can be used for simple mirror operations
#  ...as opposed to complex Lftp scripting.
# 
# It's purposefully minimalistic to accomodate customizations.
# You'll need to mod this yourself for httpS or funky passwords.
#

# this should be same for all recent h264
# foscams, so no need to modify it
cgi_cmd=/cgi-bin/CGIProxy.fcgi?cmd=startFtpServer

################################
##  Set the next 5 lines to   ##
##  reflect your camera and   ##
##  its download dir path.    ##

FOSCAM_ADDR=192.168.1.101
HTTP_PORT=88
USERNAME=MYNAME
PASSWORD=MYPASSWORD
MEDIA_DIR=/path/to/media/cam101

# This command-pair mirrors the camera that is defined by the above variables.
# You but can modify these lines if desired, but probably don't need to.
curl -v "http://${FOSCAM_ADDR}:${HTTP_PORT}${cgi_cmd}&usr=${USERNAME}&pwd=${PASSWORD}"
lftp -u $USERNAME,$PASSWORD -e "mirror -v / $MEDIA_DIR" -p 50021 ftp://${FOSCAM_ADDR}




#=================================================================================
#
# full url to call (with curl) to start ftp server...
# eg: http://192.168.1.101:88/cgi-bin/CGIProxy.fcgi?cmd=startFtpServer&usr=MYNAME&pwd=MYPASSWORD
#
# Lftp string to locally archive...
# eg: lftp -u MYNAME,MYPASSWORD -e "[mirror command]" -p 50021 ftp://192.168.1.101
#
# mirror command string to feed lftp (requires quotes)...
# eg: mirror -v / /root/media/cam101
#               | |
#               | \-- local system target path (e.g. writeable storage)
#               \---- remote system source path (e.g. camera FTP root)
#
#
# for additional cameras: copy/paste/modify "set these" lines above, then,
# after those, copy/paste the "curl" and "lftp" lines.
# Cameras will *not* mirror simultaneously unless the 'lftp' line has a
# trailing ampersand (&) to force it into the background.
#
#=================================================================================

