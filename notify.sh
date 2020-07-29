#!/bin/bash

a="/$0"; a=${a%/*}; a=${a:-.}; a=${a#/}/; BINDIR=$(cd $a; pwd)
. $BINDIR/include/global.inc.sh

test -r $SPFTRC && . $SPFTRC
NOTIFY_EMAIL=${1:-"$NOTIFY_EMAIL"}
DOMAIN=${2:-"$DOMAIN"}

NOUPDATE=$(grep "Everything OK" "$HOME/spf-tools/spf-tools/runspftools.log");

if [ "$NOUPDATE" == "Everything OK" ]; then
 echo "No Update Required"
else
 echo "SPF Update Required"

 UPDATE=$(grep '\.\.\. OK' "$HOME/spf-tools/runspftools.log");
 ERROR=$(grep 'error' "$HOME/spf-tools/runspftools.log");

 if [[ "$ERROR" != *error ]] && [[ "$UPDATE" =~ OK ]]; then
  echo "SPF Update Successful"
  echo "$UPDATE" | mailx -E -a "$HOME/spf-tools/runspftools.log" -s "[SUCCESS] SPF flatten $DOMAIN updated" $NOTIFY_EMAIL
 else
  echo "SPF Update Failed"
  echo "$ERROR" | mailx -E -a "$HOME/spf-tools/runspftools.log" -s "[ERROR] SPF flatten $DOMAIN failed" $NOTIFY_EMAIL
 fi
 
fi
