#!/bin/bash
CURRENT=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
THRESHOLD=85

if [ "$CURRENT" -gt "$THRESHOLD" ] ; then
    echo "YOUR ROOT PARTITION remaining free space is critically low. Used: $CURRENT%"
else
	echo "YOUR ROOT PARTITION free space is : $CURRENT%"
fi
