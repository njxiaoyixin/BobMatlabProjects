function funOnMDDisconnected(obj,varargin)
obj.SystemSwitch.MDDConn = 0;
fprintf('%s\tMarket Data Disconnected\n',datestr(now,'HH:MM:SS.FFF'));
obj.PauseTrade
% 当行情断线后，此事件被触发；
end

