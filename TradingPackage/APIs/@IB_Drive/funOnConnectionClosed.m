function funOnConnectionClosed(obj,varargin)
obj.SystemSwitch.MDDConn = 0;
fprintf('%s\tMarket Data Disconnected\n',datestr(now,'HH:MM:SS.FFF'));
obj.PauseTrade
obj.ConnStatus = 'Disconnected';
end