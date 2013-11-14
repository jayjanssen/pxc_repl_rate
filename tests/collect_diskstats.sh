#!/bin/bash

INTERVAL=1
while true; do
   sleep=$(date +%s.%N | awk "{print $INTERVAL - (\$1 % $INTERVAL)}")
   sleep $sleep
   date +"TS %s.%N %F %T" 
   cat /proc/diskstats
done

