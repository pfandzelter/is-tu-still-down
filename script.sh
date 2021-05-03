#!/bin/bash

git pull origin main --rebase

START=1619771400

curl webmail.tu-berlin.de &> /dev/null

FAIL=$?

cp template.html ./docs/index.html

if [ $FAIL ]; then
    sed -i -e 's/%ANSWER%/Nein/g' ./docs/index.html
else
    sed -i -e 's/%ANSWER%/Nein/g' ./docs/index.html
fi

TIME=$(TZ=Europe/Berlin LC_ALL=de_DE.utf8 date)
sed -i -e "s/%DATETIME%/$TIME/g" ./docs/index.html

END=$(TZ=Europe/Berlin date -u +%s)
DURATION=$((END-START))
DAYS=$((DURATION%86400))
DAYS=$((DURATION - DAYS))
DAYS=$((DAYS/86400))

HOURS=$((DURATION%3600))
HOURS=$((DURATION - HOURS))
HOURS=$((HOURS/3600))
HOURS=$((HOURS%24))

#echo $DAYS
#echo $HOURS
SINCE="$DAYS Tagen und $HOURS Stunden"
sed -i -e "s/%TIMESINCE%/$SINCE/g" ./docs/index.html

git add ./docs/index.html
git commit -m "$(date)"
git push