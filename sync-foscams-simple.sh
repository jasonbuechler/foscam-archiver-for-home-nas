#!/bin/csh
#
# This single script can be used for simple mirror operations
#  ...as opposed to complex Lftp scripting.
# You'll need to mod this yourself for httpS or funky passwords.
#


# set these to reflect your camera, & archive path
set foscam_addr=192.168.1.101
set http_port=88
set username=MYNAME
set password=MYPASSWORD
set media_dir=/root/media/cam101

# these should be same for all recent h264 foscams
set cgi_path=/cgi-bin/CGIProxy.fcgi 
set start_cmd=cmd=startFtpServer

curl -v "http://${foscam_addr}:${http_port}${cgi_path}?${start_cmd}&usr=${username}&pwd=${password}"

lftp -u ${username},${password} -e "mirror -v / ${media_dir}" -p 50021 ftp://${foscam_addr}

#=================================================================================
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
#=================================================================================

##############
##
## for additional cameras: copy/paste/modify "set" lines above
## and, after those, copy/paste the "curl" and "lftp" lines.
## Cameras will *not* mirror simultaneously.
##
##############


