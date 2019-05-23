#!/bin/csh
#
# This single script can be used for simple mirror operations
# (as opposed to complex Lftp scripting)
#

set username=MYNAME
set password=MYPASSWORD
set foshttp=http://192.168.1.101:88
set cgipath=/cgi-bin/CGIProxy.fcgi
set startcmd=cmd=startFtpServer

#eg: http://192.168.1.101:88/cgi-bin/CGIProxy.fcgi?cmd=startFtpServer&usr=MYNAME&pwd=MYPASSWORD

curl -v "$foshttp$cgipath?$startcmd&usr=$username&pwd=$password"
