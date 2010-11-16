#!/bin/bash

LATEST=`curl -s http://build.chromium.org/f/chromium/snapshots/chromium-rel-mac/LATEST`
CURRENT=`defaults read /Applications/Chromium.app/Contents/Info SVNRevision 2>/dev/null`
PROCESSID=`ps ux | awk '/Chromium/ && !/awk/ {print $2}'`

if [[ $LATEST -eq $CURRENT ]]; then
  echo "You're already up to date ($LATEST)"
  exit 0
fi

if [ ${#PROCESSID[*]} -gt 0 ];  then
  echo "Kill current instance of Chromium.app [y/n]"
  read confirmation
fi
if [ "$confirmation" = "y" ];  then
  for x in $PROCESSID; do
    kill -9 $x
  done
else 
  if [ "$confirmation" != "y" ]; then
    echo "Please close Chromium.app and restart the script"
    exit 0
  fi
fi

echo "Getting the latest version ($LATEST)"
curl "http://build.chromium.org/f/chromium/snapshots/chromium-rel-mac/$LATEST/chrome-mac.zip" -o /tmp/chrome-mac.zip
wait

echo "Unzipping"
unzip -o -qq /tmp/chrome-mac.zip -d /tmp
wait

echo "Moving new version"
cp -R /tmp/chrome-mac/Chromium.app /Applications
wait

echo "Cleaning up"
rm -rf /tmp/chrome-*
echo "Done"
exit 0