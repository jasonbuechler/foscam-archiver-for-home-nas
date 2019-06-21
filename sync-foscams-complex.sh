#!/bin/sh

adds="192.168.1.101:88  192.168.1.102:88  192.168.1.103:88  192.168.1.104:88"
usrs="USERNAME1         USERNAME2         USERNAME3         USERNAME4"
pwds="PASSWORD1         PASSWORD2         PASSWORD3         PASSWORD4"
dirs="/media/cam1       /media/cam2       /media/cam2       /media/cam2"

i=1
while [ $i -le $(echo $adds | wc -w) ]
do
  add=$(echo $adds | awk "{print \$$i}")
  prt=$(echo $prts | awk "{print \$$i}")
  usr=$(echo $usrs | awk "{print \$$i}")
  pwd=$(echo $pwds | awk "{print \$$i}")
  dir=$(echo $dirs | awk "{print \$$i}")

  url="http://$add/cgi-bin/CGIProxy.fcgi?cmd=startFtpServer&usr=$usr&pwd=$pwd"
  ip=$(echo $add | cut -d : -f 1)

  echo curl -v \"$url\"
  curl -v "$url"

  echo lftp -u $usr,$pwd -e \"mirror -v / $dir\" -p 50021 ftp://$ip
  lftp -u $usr,$pwd -e "mirror -v / $dir" -p 50021 ftp://$ip

  i=`expr $i + 1`
done
