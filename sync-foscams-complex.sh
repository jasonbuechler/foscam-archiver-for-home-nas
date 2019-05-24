#!/bin/tcsh

set aa = (192.168.1.101 192.168.1.102 192.168.1.103 192.168.1.104)
set uu = (USERNAME USERNAME USERNAME USERNAME)
set pp = (PASSWORD PASSWORD PASSWORD PASSWORD)
set dd = ("~/cam101" "~/cam102" "~/cam103" "~/cam104")

: ' It is up to YOU to make sure you have '
: ' an equal # of elements in each set    '
: ' (and DONT use commas)                 '
: ' And dont judge me for these buttfugly '
: ' variables. csh/tcsh is AWFUL.         '

set port = 88
set n = $#aa
set i=1
while ( $i <= $n )
  set a = $aa[$i]
  set u = $uu[$i]
  set p = $pp[$i]
  set d = $dd[$i]


  set curl_command=`echo curl -v "http://${a}:$port/cgi-bin/CGIProxy.fcgi"`
  set curl_params="?cmd=startFtpServer&usr=$u&pwd=$p"
  echo "$curl_command$curl_params"
  curl -v "http://${a}:${port}/cgi-bin/CGIProxy.fcgi?cmd=startFtpServer&usr=$u&pwd=$p"

  set lftp_command=`echo lftp -u $u,$p -e \"mirror -v / $d\" -p 50021 ftp://$a`
  echo $lftp_command
  eval "$lftp_command &"

  @  i++
end
