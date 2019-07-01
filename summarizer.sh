#!/bin/sh


# get YYYYMMDD digits from exactly 1d ago, then find all
# directories relative to PWD that start with YYYYMMDD_
YEST=$(date -v -1d '+%Y%m%d')
DIRS=$(find . -type d -name "${YEST}_*")

echo "** yesterday: $YEST"
echo "**   execute: find . -type d -name \"${YEST}_*\""
echo "$DIRS"

## DEPRECATED:
# use 'echo' to force 'read' to iterate through source dirs 
# (-r flag to prevent escape sequences)
#echo "$DIRS" | while read -r DIR


i=1
# loop from 1 to the # of lines in $DIRS
# (kludge because Bourne shell has no arrays to loop thru)
while [ $i -le $(echo "$DIRS" | wc -l) ]
do

  # assign the i'ith line of $DIRS to the $DIR var
  DIR=$(echo "$DIRS" | awk "NR==$i")
  # (a bit inefficient but MUCH less awkward than piping an echo'd
  # var into the stdin of a 'read' loop, AND allows us to avoid
  # ffmpeg's stdin issue: http://mywiki.wooledge.org/BashFAQ/089)

  
  # make target dir = everything before /record/
  # make (non-suffix) filename = YYYYMMDD_hhmmss
  TARGET=$( echo "$DIR" | sed "s/\/record\/.*//" )
  FNAME=$( echo "$DIR" | sed "s/.*\///")

  # feed the list all the avi files in source directory into 'sort'  
  # and alpha-sort by YYYYMMDD and hhmmss to combine SD/MD in order
  # then finally clean up the file paths to be relative to $TARGET
  # (since ffmpeg's concat routine expects that relativity)
  ls -1 $DIR/*.avi | sort -t_ -k4,5 | \
  sed "s/.*\/record\//record\//" | sed "s/.*/file '&'/" > $TARGET/$FNAME.txt


  echo "** filenames list: $TARGET/$FNAME.txt"
  echo "** combined video: $TARGET/$FNAME.avi"
  echo "** executing: ffmpeg -y -f concat -safe 0 -i \"$TARGET/$FNAME.txt\" -c copy -an \"$TARGET/$FNAME.avi\""

  # concat all the files in the .txt, and save (overwrite: -y) to an *avi
  # (</dev/null is probably unnecessary now we aren't piping into 'read')
  ffmpeg -y -f concat -safe 0 -i "$TARGET/$FNAME.txt" -c copy -an "$TARGET/$FNAME.avi" </dev/null

  i=`expr $i + 1`
done




#
# date -v -1d '+%Y%m%d'
# 20190629
# 
# find . -type d -name '20190628_*'
# ./cam102/C1_C4D655400B18/record/20190628/20190628_005407
# ./cam104/C1_C4D65540BEDF/record/20190628/20190628_003031
# ./cam103/IPCamera/C1_C4D6553F139E/record/20190628/20190628_000410
# ./cam107/IPCamera/C2_00626E6133BC/record/20190628/20190628_200537
# ./cam107/IPCamera/C2_00626E6133BC    <== $TARGET
#                                                   /‾‾‾$FNAME‾‾‾‾\
# ./cam107/IPCamera/C2_00626E6133BC/record/20190628/20190628_003518/SDalarm_20190628_003211.avi
# ./cam107/IPCamera/C2_00626E6133BC/record/20190628/20190628_003518/MDalarm_20190628_003518.avi
# \_______k1_________/ \___________k2______________________/ \____k3______/ \__k4__/ \__k5____/
# 
#                           ^^ field keys using _ delimiter ^^
#          could easily fall apart if user's folder structure uses underscores :(
#
# ./cam107/IPCamera/C2_00626E6133BC/
#   sorted avi list to concat ==>   20190628_003518.txt
#   filepath relative to .txt ==>   record/20190628/20190628_003518/SDalarm_20190628_003518.avi
#                                   record/20190628/20190628_003518/MDalarm_20190628_003940.avi
#
