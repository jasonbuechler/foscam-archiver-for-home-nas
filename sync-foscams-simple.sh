#!/bin/csh
#
# This single script can be used for simple mirror operations
# (as opposed to complex Lftp scripting)
#

set fos_addr=192.168.1.101
set http_port=:88
set username=MYNAME
set password=MYPASSWORD
set cgi_path=/cgi-bin/CGIProxy.fcgi
set start_cmd=cmd=startFtpServer
set media_dir=/root/media/cam101

# full url to call (with curl) to start ftp server...
# eg: http://192.168.1.101:88/cgi-bin/CGIProxy.fcgi?cmd=startFtpServer&usr=MYNAME&pwd=MYPASSWORD

curl -v "http://$fos_addr$http_port$cgi_path?$start_cmd&usr=$username&pwd=$password"

lftp -u $username,$password -c "mirror -v / $media_dir" -p 50021 ftp://$fos_addr

# Lftp string to locally archive
# eg: lftp -u MYNAME,MYPASSWORD -c "[mirror command]" -p 50021 ftp://192.168.1.101
# eg: "mirror -v / /root/media/cam101"
#                | |
#                | \-- local target path
#                \---- remote site source path



