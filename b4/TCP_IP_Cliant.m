clc
clear all
tcpipClient = tcpip('127.0.0.1',6340,'NetworkRole','Client');

set(tcpipClient,'Timeout',30);
%fopen(tcpipClient);
%a='yah!! we could make it';
%a="83";
%fwrite(tcpipClient,a);
while(1)
for x=1:100
    disp(x);
    x = int2str(x);
    fopen(tcpipClient);
    fwrite(tcpipClient,x);
    fclose(tcpipClient);
    pause(1);
end
end