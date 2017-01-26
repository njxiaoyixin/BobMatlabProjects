function GetOrder(obj,orderId,clientOnly)
% Order的结构- Type(openOrderEx,openOrderEnd)
% orderId
% contract
% order
% orderState:
% status('PendingCancel'),initMargin,maintMargin,equityWithLoad,commission
% minCommision,maxCommision,commisionCurrency,warningText

%避免重复订阅
%             evtListeners = obj.LoginId.eventlisteners;
%             i = strcmp(evtListeners(:,1),'openOrderEx');
%             obj.LoginId.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
%             i = strcmp(evtListeners(:,1),'openOrderEnd');
%             obj.LoginId.unregisterevent({evtListeners{i,1} evtListeners{i,2}});

if nargin <3
    clientOnly = false;
end
try
    %                 Order = orders(obj.LoginId,clientOnly,@(varargin) obj.funOnOrder(varargin{:}));
    eventNames = {'openOrderEnd','openOrderEx','orderStatus'};
    evtListeners = obj.LoginId.Handle.eventlisteners;
    for i = 1:length(eventNames)
        k = strcmp(evtListeners(:,1),eventNames{i});
        if ~any(k) || isempty(k)
            obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnMarketData(varargin{:})});
        end
    end
    
    if clientOnly
        obj.LoginId.Handle.reqOpenOrders;
    else
        obj.LoginId.Handle.reqAllOpenOrders;
    end
catch Err
    assignin('base','Err',Err)
    disp(evalin('base','ibBuiltInErrMsg'))
end
end