#!/bin/bash
HTTP_URL="http://192.168.178.1:9000/writePinOn/24"
(
 	# Wait for lock on /var/lock/.myscript.exclusivelock (fd 200) for 10 seconds
	flock -x -w 0 200 || exit 1
	#wget http://192.168.178.1:9000/writePinOn/24 1>/dev/null 2>/dev/null
	curl $HTTP_URL
        if [ $? != 0 ]; then
        	curl $HTTP_URL 1>/tmp/log1 2>/tmp/log2
        	if [ $? != 0 ]; then
        		curl $HTTP_URL 1>/tmp/log1 2>/tmp/log2
        	fi
        fi
        sleep 60;
) 200>/var/lock/.myscript.exclusivelock
