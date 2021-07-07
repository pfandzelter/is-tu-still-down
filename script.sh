#!/bin/bash

git pull origin main --rebase

START=1619771400


cp template.html ./docs/index.html

TIME=$(TZ=Europe/Berlin LC_ALL=de_DE.utf8 date)
sed -i -e "s/%DATETIME%/$TIME/g" ./docs/index.html

# test tuport
curl -m 30 "https://tuport.sap.tu-berlin.de/" &> /dev/null

FAIL=$?

if [ $FAIL -ne 0 ]; then
    sed -i -e "s/%%TUPORT-ANSWER%%/Nein/g" ./docs/index.html
    sed -i -e "s/%%TUPORT-ANSWER-CODE%%/no/g" ./docs/index.html
else
    sed -i -e "s/%%TUPORT-ANSWER%%/Ja/g" ./docs/index.html
    sed -i -e "s/%%TUPORT-ANSWER-CODE%%/yes/g" ./docs/index.html
fi


# test qispos
curl --fail -m 30 "https://www3.ib.tu-berlin.de/qisserver/rds?state=user&type=0" &> /dev/null

FAIL=$?

if [ $FAIL -ne 0 ]; then
    sed -i -e "s/%%QISPOS-ANSWER%%/Nein/g" ./docs/index.html
    sed -i -e "s/%%QISPOS-ANSWER-CODE%%/no/g" ./docs/index.html
else
    sed -i -e "s/%%QISPOS-ANSWER%%/Ja/g" ./docs/index.html
    sed -i -e "s/%%QISPOS-ANSWER-CODE%%/yes/g" ./docs/index.html
fi


# test tubcloud
curl -m 30 "https://tubcloud.tu-berlin.de/" &> /dev/null

FAIL=$?

if [ $FAIL -ne 0 ]; then
    sed -i -e "s/%%TUBCLOUD-ANSWER%%/Nein/g" ./docs/index.html
    sed -i -e "s/%%TUBCLOUD-ANSWER-CODE%%/no/g" ./docs/index.html
else
    sed -i -e "s/%%TUBCLOUD-ANSWER%%/Ja/g" ./docs/index.html
    sed -i -e "s/%%TUBCLOUD-ANSWER-CODE%%/yes/g" ./docs/index.html
fi


# test gitlab
curl -m 30 "https://git.tu-berlin.de/" &> /dev/null

FAIL=$?

if [ $FAIL -ne 0 ]; then
    sed -i -e "s/%%GITLAB-ANSWER%%/Nein/g" ./docs/index.html
    sed -i -e "s/%%GITLAB-ANSWER-CODE%%/no/g" ./docs/index.html
else
    sed -i -e "s/%%GITLAB-ANSWER%%/Ja/g" ./docs/index.html
    sed -i -e "s/%%GITLAB-ANSWER-CODE%%/yes/g" ./docs/index.html
fi


# end

END=$(TZ=Europe/Berlin date -u +%s)
DURATION=$((END-START))

MONTHS=$((DURATION%2678400))
MONTHS=$((DURATION - MONTHS))
MONTHS=$((MONTHS/2678400))

DAYS=$((DURATION%86400))
DAYS=$((DURATION - DAYS))
DAYS=$((DAYS/86400))
DAYS=$((DAYS%31))

HOURS=$((DURATION%3600))
HOURS=$((DURATION - HOURS))
HOURS=$((HOURS/3600))
HOURS=$((HOURS%24))

#echo $DAYS
#echo $HOURS

SINCE=""

if [ 1 -eq $MONTHS ]; then
    SINCE="1 Monat"
elif [ $MONTHS -gt 1 ]; then
    SINCE="$MONTHS Monaten"
fi

if [ $HOURS -gt 0  -a  $DAYS -gt 0 ] ; then
    SINCE="$SINCE,"
elif [ $HOURS -eq 0  -a  $DAYS -gt 0 ]; then
    SINCE="$SINCE und"
else
    SINCE="$SINCE"
fi

if [ 1 -eq $DAYS ]; then
    SINCE="$SINCE 1 Tag"
elif [ $DAYS -gt 1 ]; then
    SINCE="$SINCE $DAYS Tagen"
fi

if [ 1 -eq $HOURS ]; then
    SINCE="$SINCE und 1 Stunde"
elif [ $HOURS -gt 1 ]; then
    SINCE="$SINCE und $HOURS Stunden"
fi

sed -i -e "s/%TIMESINCE%/$SINCE/g" ./docs/index.html

git add ./docs/index.html
git commit -m "$(date)"
git push
