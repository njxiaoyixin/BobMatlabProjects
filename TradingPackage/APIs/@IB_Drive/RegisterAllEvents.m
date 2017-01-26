function RegisterAllEvents(obj)
eventNames ={'connectionClosed'};
for i = 1:length(eventNames)
    obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnConnectionClosed(varargin{:})});
end

eventNames = {'tickSize','tickPrice','tickSnapshotEnd'};
for i = 1:length(eventNames)
    obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnMarketData(varargin{:})});
end
% Get Positions
eventNames = {'updatePortfolioEx','accountDownloadEnd'};
for i = 1:length(eventNames)
    obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnPosition(varargin{:})});
end
% Get Orders
eventNames = {'openOrderEnd','openOrderEx','orderStatus'};
for i = 1:length(eventNames)
    obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnOrder(varargin{:})});
end
% Get Account
eventNames = {'updateAccountTime','updateAccountValue'};
for i = 1:length(eventNames)
    obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnAccount(varargin{:})});
end
% Get Trades
eventNames = {'execDetailsEx','execDetailsEnd'};
for i = 1:length(eventNames)
    obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnTrade(varargin{:})});
end
end