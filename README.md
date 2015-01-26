# montacarichi
Montacarichi project aims to send an HTTP request to a webserver (in this case a raspberry pi running a little flask http server that drives a service elevator by powering on some GPIO pins) whenever a Clouditalia orchestra geographical voip number is called.
You can get free Clouditalia orchestra voip numbers at http://www.clouditaliaorchestra.com/ (you have to signup first and then to confirm your identity).
After you got a voipnumber you can easily setup this project with docker and fig.

First build your Dockerfile like this

```
# DOCKERFILE FOR SIP AUTOMATION TASKS WITH CLOUDITALIAORCHESTRA.COM

FROM ubuntu:14.04

MAINTAINER Alessio Garzi "gun101@email.it"

# install sipsak curl and nodejs
RUN apt-get update && apt-get install -y --no-install-recommends \
			sipsak \
			curl \
			nodejs \
			git \
			&& rm -rf /var/lib/apt/lists/*


# INSTALL SCRIPTING FILES
# registra.sh sends SIP register messages to voip.eutelia.it

# updserver.js is a daemon waiting for incoming invite SIP messages, when
# this happens it launches sendpinon.sh

# sendpinon24.sh generates a new httprequest with curl, on the other side
# there is a raspberrypi that makes some stuff (in this case it powers the
# pin24 on)

RUN git config --global http.sslVerify false && git clone https://github.com/Ozzyboshi/montacarichi.git
RUN ln -s /montacarichi/registra.sh /registra.sh
RUN ln -s /montacarichi/udpserver.js /udpserver.js
RUN ln -s /montacarichi/sendpinon24.sh /sendpinon24.sh

# EXPOSE SIP DEFAULT PORT 5060 , MY NODEJS UDPSERVER IS LISTENING HERE
EXPOSE 5060/udp

# registra.sh creates a crontab file responsibile for registering the sip
# number and starts cron and the udpserver
ENTRYPOINT /registra.sh
```

In this example I assume that the virtual container is listening to port 5060 but you can customize this port according to your own needs.

After that i build the container with fig, this is a fig.yml example
```
num1:
  build: .
  ports:
   - "5060:5060/udp"
  environment:
   - SIP_LOGIN=#clouditaliaorchestranumber#
   - SIP_PASSWORD=#clouditaliaorchestrapassword#
   - SIP_PORT=5060
   - IP=#your host public ip#
   - WHITELISTED_NUMBERS=3381234567,3331234567 
   - HTTP_URL=http://192.168.1.1:9000/writePinOn/24
```

With this fig file, Docker will run a virtual container that listens to port 5060, any incoming packet received from the host on port 5060 will be natted to your virtual container.
Inside the virtual container, the udpserver will check if the caller is on the WHITELISTED_NUMBERS field, if yes curl will generate a httprequest for 'http://192.168.1.1:9000/writePinOn/24'
Always remember to expose the container port in the docker file according to the port section of the yml file.
