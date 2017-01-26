function GetMarketData(obj,contractId)
f='100';
if ischar(f)
    f = cellstr(f);
end
fldList = f{1};
for i = 2:length(f)
    fldList = [fldList ',' f{i}]; %#ok
end

if nargin >= 2 && ~isempty(contractId) %订阅单个合约行情
    currentContractId = 1:numel(obj.Contract);
    idx =find(currentContractId==contractId, 1) ;
    if isempty(idx)
        warning('No corresponding contract found!')
        return
    else
        thisContractSet = {obj.Contract(idx).other.ibContract};
        thisContractIdSet = contractId;
        obj.TickerId(contractId) = randperm(10000,1);
        %                     obj.TickerId(contractId) = obj.LoginId.realtime(thisContractSet,'100',@(varargin)obj.funOnMarketData(varargin{:}));
    end
else  %订阅所有的合约行情
    if numel(obj.Contract) >0
        thisContractSet = cell(1,numel(obj.Contract));
        thisContractIdSet = 1:numel(obj.Contract);
        obj.TickerId    = randperm(10000,numel(thisContractSet));
        for i=1:numel(obj.Contract)
            thisContractSet{i} = obj.Contract(i).other.ibContract;
        end
    else
        warning('No contract set!')
        return
    end
end
try
    eventNames = {'tickSize','tickPrice','tickSnapshotEnd'};
    evtListeners = obj.LoginId.Handle.eventlisteners;
    for i = 1:length(eventNames)
        k = strcmp(evtListeners(:,1),eventNames{i});
        if ~any(k) || isempty(k)
            obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnMarketData(varargin{:})});
        end
    end
    
    for i=1:numel(thisContractSet)
        try
            obj.LoginId.Handle.reqMktDataEx(obj.TickerId(thisContractIdSet(i)),thisContractSet{i},fldList,0,obj.LoginId.Handle.createTagValueList)
            %                         obj.TickerId(i) = obj.LoginId.realtime(thisContractSet{i},'100',@(varargin)obj.funOnMarketData(varargin{:}));
        catch Err1
            assignin('base','Err1',Err1)
            %Version pre 9.7 API call
            obj.LoginId.Handle.reqMktDataEx(obj.TickerId(thisContractIdSet(i)),thisContractSet{i},fldList,0)
        end
    end
    %                 obj.TickerId = obj.LoginId.realtime(thisContractSet,'100');
catch Err
    assignin('base','Err',Err)
    disp(evalin('base','ibBuiltInErrMsg'))
end
disp([datestr(now,'HH:MM:SS'),'---ib Market Data Subscription Succeeded.---'])
end