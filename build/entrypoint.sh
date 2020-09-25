#!/bin/sh
PARAMS=$@
echo "[###] crontab-executor started with these parameters: $PARAMS"

TMP_CRONTAB=/tmp/crontab

echo
echo "[###] adding these crontab files:"
echo

CRONTABS= # beginning with an empty list
if [ $# -eq 1 ] 
then # adding crontab or crontabs (in case of asterisks) within /etc/cron
    PARAM="$1" # avoing expansion of asterisk. for some reason this is only needed if invoked with exactly one parameter
    CRONTABS="$CRONTABS $(ls /etc/cron/$PARAM || exit 1)"
else # adding given crontabs within /etc/cron
    for PARAM in $PARAMS
    do
        CRONTABS="$CRONTABS $(ls /etc/cron/$PARAM || exit 1)"
    done
fi

# sorting and deduplicating collected crontab list
for CRONTAB in $(ls -1 $CRONTABS | sort | uniq || exit 2)
do # filling TMP_CRONTAB
    echo "* $CRONTAB"
    (
        cat "$CRONTAB" || exit 3
        echo
    ) >> ${TMP_CRONTAB}
done
crontab ${TMP_CRONTAB} || exit 4

echo
echo "[###] resulting crontab:"
echo
crontab -l

echo
echo "[###] cron starting now"
echo

# DOCKERFILE appends start command to the bottom
