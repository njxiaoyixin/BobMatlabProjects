function GetAccount(obj,AccountNumber)
if nargin<2
    AccountNumber = obj.account;
end
try
    %                 Account = accounts(obj.LoginId,AccountNumber);%,@(varargin) obj.funOnAccount(varargin{:}));
    eventNames = {'updateAccountTime','updateAccountValue'};
    evtListeners = obj.LoginId.Handle.eventlisteners;
    for i = 1:length(eventNames)
        k = strcmp(evtListeners(:,1),eventNames{i});
        if ~any(k) || isempty(k)
            obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnMarketData(varargin{:})});
        end
    end
    obj.LoginId.Handle.reqAccountUpdates(true,AccountNumber)
catch Err
    assignin('base','Err',Err)
    disp(evalin('base','ibBuiltInErrMsg'))
end
end