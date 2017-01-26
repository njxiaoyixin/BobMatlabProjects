close all;
clear all;
clear classes;
clc;

%%

% create a wrapper class and connect...
tws = CTws;
tws.connect;

%% subscribe to a symbol and show current events
tws.subscribe('SPY');
tws.debug = 1; % you should now see events pouring in...

%% show current status of a subscription
tws.debug = 0;
clc;

tws.show('SPY');

%% now create an event listener and start displaying data
l = CListener('SPY');
l.startListening(tws,'trade');

%% clear listener
l.stopListening;
clear l;


%% disconnect from tws
tws.disconnect;
clear tws;