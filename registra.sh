#! /bin/bash
if [ -z "$SIP_LOGIN" ]; then
	echo >&2 'error: siplogin is uninitialized'
	echo >&2 '  Did you forget to add -e SIP_LOGIN=... ?'
	exit 1
fi
if [ -z "$SIP_PASSWORD" ]; then
	echo >&2 'error: sippassword is uninitialized'
	echo >&2 '  Did you forget to add -e SIP_PASSWORD=... ?'
	exit 1
fi
#IP=$(curl --silent ipinfo.io/ip)
if [ -z "$IP" ]; then
	echo >&2 'error: cannot get public ip address'
	echo >&2 ' Is this host connected to the internet ?'
	exit 1
fi
echo '*/10 * * * * /bin/bash -c "sipsak -H '$IP' -i -U -d -n -x 1200 -C sip:'$SIP_LOGIN'@'$IP':'$SIP_PORT' -s sip:'$SIP_LOGIN'@voip.eutelia.it -U -d -n -x 1200 -vvv -a '$SIP_PASSWORD' 1> /tmp/logstdout 2> /tmp/stderr" ' > /tmp/registra
crontab /tmp/registra
rm /tmp/registra
cron
bash -c "nodejs /udpserver.js"