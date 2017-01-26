function contractId = AddContract(obj,contractInfo)
% contractInfo的所有要素：
% 常用: symbol, secType, exchange, currency, multiplier
% 所有：comboLegs conId comboLegsDescrip conId currency exchange expiry includeExpired
% localSymbol multiplier primaryExchange right secId secIdType
% secType strike symbol tradingClass underComp

%ContractDetail包含
%              conId: 81037235
%               symbol: 'CL'
%              secType: 'FUT'
%               expiry: '20160621'
%               strike: 0
%                right: ''
%           multiplier: '1000'
%             exchange: 'NYMEX'
%      primaryExchange: ''
%             currency: 'USD'
%          localSymbol: 'CLN6'
%         tradingClass: 'CL'
%       includeExpired: 0
%            comboLegs: []
%            underComp: []
%     comboLegsDescrip: ''
%            secIdType: ''
%                secId: ''
if strcmpi(obj.ConnStatus,'Disconnected')
    contractId = 0;
    return
end

if ~isstruct(contractInfo) && ischar(contractInfo)
    thisContractInfo.localSymbol = contractInfo;
    contractInfo = thisContractInfo;
elseif strcmpi(class(contractInfo),'BaseContract')  % 如果输入的是BaseContract
    contractInfo = get(contractInfo);
end

% 对HK Stock的symbol进行特殊处理,symbol前面不得含有0
if isfield(contractInfo,'symbol') && isfield(contractInfo,'sectype') && ...
        isfield(contractInfo,'exchange') && strcmpi(contractInfo.exchange,'SEHK') &&...
        strcmpi(contractInfo.secType,'STK')
    contractInfo.symbol = num2str(str2double(contractInfo.symbol));
end

ibContract = obj.LoginId.Handle.createContract;
ibFields = fieldnames(get(ibContract));
Fields = fieldnames(contractInfo);
for k=1:numel(Fields)
    if ~isempty(contractInfo.(Fields{k})) && any(contractInfo.(Fields{k})~=0) && any(strcmpi(ibFields,Fields{k}))
        ibContract.(Fields{k}) = contractInfo.(Fields{k});
    end
end
if isempty(contractInfo.exchange) && ~isempty(contractInfo.primaryExchange)
    ibContract.exchange = contractInfo.primaryExchange;
end
contractDetails_Raw         = contractdetails(obj.LoginId,ibContract);

if ~isstruct(contractDetails_Raw)
    pause(0.5)
    contractDetails_Raw         = contractdetails(obj.LoginId,ibContract);
end
try
    contractDetails             = get(contractDetails_Raw.summary) ;
catch
    if regexp(contractDetails_Raw,'No security definition has been found for the request','Once')
        disp(['Product ',contractInfo.symbol,' Not Found! Please Check the Input'])
        return
    end
    if regexp(contractDetails_Raw,'Error validating request')
        disp('ContractDetailsExtracting Error!')
        return
    end
end

fields = fieldnames(ibContract);
fieldList = {'conId','expiry','localSymbol','tradingClass'};
for i=1:numel(fields)
    if any(strcmpi(fields{i},fieldList))
        ibContract.(fields{i})=contractDetails.(fields{i});
    end
end

contractDetails.minTick     = contractDetails_Raw.minTick;

%避免添加localSymbol重复的Contract
localSymbol                  = contractDetails.localSymbol;
contractId                   = numel(obj.Contract)+1;
if numel(obj.Contract)>0
    currentLocalSymbol = arrayfun(@(x)obj.Contract(x).localSymbol,1:numel(obj.Contract),'UniformOutput',false);
    thisContractId = find(strcmpi(currentLocalSymbol,localSymbol),1);
    if ~isempty(thisContractId)
        contractId = thisContractId;
    end
end

obj.Contract(contractId,1).insertTime       = datestr(now,31);
obj.Contract(contractId,1).localSymbol      = contractDetails.localSymbol;
obj.Contract(contractId,1).multiplier       = str2double(contractDetails.multiplier);
obj.Contract(contractId,1).minTick          = contractDetails.minTick;
obj.Contract(contractId,1).symbol           = contractDetails.symbol;
obj.Contract(contractId,1).expiry           = contractDetails.expiry;
obj.Contract(contractId,1).currency         = contractDetails.currency;
obj.Contract(contractId,1).secType          = contractDetails.secType;
obj.Contract(contractId,1).other.contractDetails  = contractDetails;
obj.Contract(contractId,1).other.ibContract = ibContract;

obj.MarketData(contractId,1) = BaseMarketData;
disp([datestr(now,'HH:MM:SS'),'---Contract ',num2str(contractId),' ',contractDetails.localSymbol,' 添加成功.---'])
% pause(1)  %不停止的话ContractDetail读取的数据会有问题
end