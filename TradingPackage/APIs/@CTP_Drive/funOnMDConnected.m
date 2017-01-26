function funOnMDConnected(obj,varargin)
obj.SystemSwitch.MDDConn = 1;
fprintf('%s\tMarket Data Connected\n',datestr(now,'HH:MM:SS.FFF'));
obj.ResumeTrade
% 当行情连线后，此事件被触发；

end

