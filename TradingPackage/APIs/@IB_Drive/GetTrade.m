function GetTrade(obj)%查询成交记录
% ExecutionFilter字段:
% acctCode,clientId, exchange,secType,side,symbol,time
f = obj.LoginId.Handle.createExecutionFilter;
%             Fields = fieldnames(obj.Contract(contractId).contractInfo);
%             for k=1:numel(Fields)
%                 f.(Fields{k}) = obj.Contract(contractId).contractInfo.(Fields{k});
%             end
try
    %                 Trade = obj.LoginId.executions(f,@(varargin) obj.funOnTrade(varargin{:}));
    %                 Trade = obj.LoginId.executions(f);
    eventNames = {'execDetailsEx','execDetailsEnd'};
    evtListeners = obj.LoginId.Handle.eventlisteners;
    for i = 1:length(eventNames)
        k = strcmp(evtListeners(:,1),eventNames{i});
        if ~any(k) || isempty(k)
            obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnMarketData(varargin{:})});
        end
    end
    obj.LoginId.Handle.reqExecutionsEx(1,f)
catch Err
    assignin('base','Err',Err)
    disp(evalin('base','ibBuiltInErrMsg'))
    %                 Trade=[];
end
end