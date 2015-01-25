var PORT = 5060;
var HOST = '0.0.0.0';

var dgram = require('dgram');
var server = dgram.createSocket('udp4');

server.on('listening', function () {
    var address = server.address();
    console.log('UDP Server listening on ' + address.address + ":" + address.port+" for number :"+process.env.SIP_LOGIN+' on IP :'+process.env.IP);
});
        
server.on('message', function (message, remote) {
    var messagestr=message.toString();
    console.log(messagestr);
    if(messagestr.indexOf('INVITE sip:'+process.env.SIP_LOGIN+'@'+process.env.IP+':5060 SIP/2.0') > -1)
    {
        var trovato=0;
        var arr = process.env.WHITELISTED_NUMBERS.split(",");
        arr = arr.map(function (val) {
            if (messagestr.indexOf('From: <sip:'+val+'@')>-1)
                trovato=1;
        });
        /*if ((messagestr.indexOf('From: <sip:3381625435@')>-1)||(messagestr.indexOf('From: <sip:3336344407@')>-1))*/
        if (trovato==1)
        {
            console.log(remote.address + ':' + remote.port +' - ' + message);
            var exec = require('child_process').exec;
            exec('/bin/bash -c "/sendpinon24.sh"', function (error, stdout, stderr) {
              // output is in stdout
              });
        }
    }
});
            
server.bind(PORT, HOST);