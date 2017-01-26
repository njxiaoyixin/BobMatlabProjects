function GetMarketData(obj,contractId,fields)
%处理订阅的fields
[InternalFields,WindFields] = obj.GenerateFields();
if nargin <3
    fields = InternalFields;
end
if ischar(fields)
    fields = regexp(fields,',','split');
end
k=1;
thisWindFields_Cell = cell(1,numel(fields));
for i=1:numel(fields)
    fieldIdx = find(strcmpi(InternalFields,fields{i}),1);
    if ~isempty(fieldIdx)
        thisWindFields_Cell{k} = WindFields{fieldIdx};
        k=k+1;
    else
        disp(['Input field ',fields{i},' not found!'])
    end
end
thisWindFields = [];
for i=1:numel(thisWindFields_Cell)
    if ~isempty(thisWindFields_Cell{i})
        if isempty(thisWindFields)
            thisWindFields =thisWindFields_Cell{i};
        else
            thisWindFields = [thisWindFields,',',thisWindFields_Cell{i}];
        end
    end
end

if nargin >= 2 && ~isempty(contractId) %订阅单个合约行情
    if contractId>numel(obj.Contract)
        warning('No corresponding contract found!')
        return
    else
        thisLocalSymbolSet = obj.Contract(contractId).localSymbol;
    end
else  %订阅所有的合约行情
    if numel(obj.Contract) >0
        %                     thisLocalSymbolSet = cell(1,numel(obj.Contract));
        %                     for i=1:numel(obj.Contract)
        %                         thisLocalSymbolSet{i} = obj.Contract(i).localSymbol;
        %                     end
        thisLocalSymbolSet = {obj.Contract.localSymbol};
    else
        warning([datestr(now,'HH:MM:SS'),'No contract set!'])
        return
    end
end
%             try
if ~strcmpi(obj.ConnStatus,'OK')
    disp([datestr(now,'HH:MM:SS'),'---Market Data Source Not Connected! Market Data Subscription Canceled.---'])
    return
end
if iscell(thisLocalSymbolSet)
    for i=1:numel(thisLocalSymbolSet)
        %获取一个合约当前最新行情数据。
        %先获取一次行情
        %                         obj.MarketData(contractId) = BaseMarketData;
        [w_wsq_data,w_wsq_codes,w_wsq_fields,w_wsq_times,w_wsq_errorid,w_wsq_reqid] = obj.LoginId.wsq(thisLocalSymbolSet{i},thisWindFields);
        obj.LoginId.wsq(thisLocalSymbolSet{i},thisWindFields,@(varargin) obj.funOnMarketData(varargin{:}));
        if w_wsq_errorid ~=0
            disp(['Error Id: ',num2str(w_wsq_errorid)])
        else
            obj.AssignMarketData(w_wsq_data,w_wsq_codes,w_wsq_fields);
        end
    end
else
    %                     obj.MarketData(contractId) = BaseMarketData;
    [w_wsq_data,w_wsq_codes,w_wsq_fields,w_wsq_times,w_wsq_errorid,w_wsq_reqid] = obj.LoginId.wsq(thisLocalSymbolSet,thisWindFields);
    obj.LoginId.wsq(thisLocalSymbolSet,thisWindFields,@(varargin) obj.funOnMarketData(varargin{:}));
    if w_wsq_errorid ~=0
        disp(['Error Id: ',num2str(w_wsq_errorid)])
    else
        obj.AssignMarketData(w_wsq_data,w_wsq_codes,w_wsq_fields);
    end
end
disp([datestr(now,'HH:MM:SS'),'---Wind Market Data Subscription Succeeded.---'])
%             catch Err
%                 disp(Err.message)
%             end
end