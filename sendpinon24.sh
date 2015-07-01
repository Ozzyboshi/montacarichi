#!/bin/bash
(
 	# Wait for lock on /var/lock/.myscript.exclusivelock (fd 200) for 10 seconds
	flock -x -w 0 200 || exit 1
	curl --connect-timeout 10 $HTTP_URL
        if [ $? != 0 ]; then
        	curl --connect-timeout 10 $HTTP_URL 1>/tmp/log1 2>/tmp/log2
        	if [ $? != 0 ]; then
        		curl --connect-timeout 10 $HTTP_URL 1>/tmp/log1 2>/tmp/log2
        	fi
        fi
        sleep 60;
) 200>/var/lock/.myscript.exclusivelock
