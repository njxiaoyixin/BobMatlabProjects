function contractId = AddContract(obj,contractInfo)
if ~isstruct(contractInfo) && ischar(contractInfo)
    thisOrderInfo.localSymbol = contractInfo;
    contractInfo = thisOrderInfo;
end

if any(strcmpi(contractInfo.localSymbol(1:2),{'IF','IH','IC'} ))
    localSymbol                  = upper(contractInfo.localSymbol);
else
    localSymbol                  = lower(contractInfo.localSymbol);
end

if isfield(contractInfo,'secType')
    secType = contractInfo.secType;
else
    secType = 'FUT';
end

if strcmpi(secType,'FUT')
    ia = regexpi(localSymbol,'\d\d\d\d','start');
    symbol = localSymbol(1:ia-1);
else
    symbol = localSymbol;
end

contractId                       = numel(obj.Contract)+1;
if numel(obj.Contract)>0
    currentLocalSymbol = arrayfun(@(x)obj.Contract(x).localSymbol,1:numel(obj.Contract),'UniformOutput',false);
    thisContractId = find(strcmpi(currentLocalSymbol,localSymbol),1);
    if ~isempty(thisContractId)
        contractId = thisContractId;
    end
end

[w_tdays_data]=obj.LoginId.tdaysoffset(0,today);
lastTradeDay = w_tdays_data{1,1};
[data] = obj.LoginId.wsd(localSymbol,'contractmultiplier,mfprice,dlmonth,sccode',lastTradeDay,lastTradeDay);
if ischar(data{1,1}) && regexp(data{1},'quota exceeded')
    error('Wind Quota Exceeded! Fuck!')
end
multiplier = data{1,1};
minTickStr = data{1,2};
expiry     = data{1,3};
descrption = data{1,4};

A  = isstrprop(minTickStr,'digit');
B  = minTickStr(A);
minTick = str2double(B);

obj.Contract(contractId,1).insertTime             = datestr(now,31);
obj.Contract(contractId,1).localSymbol            = localSymbol;
obj.Contract(contractId,1).symbol                 = symbol;
obj.Contract(contractId,1).multiplier             = multiplier;
obj.Contract(contractId,1).minTick                = minTick;
obj.Contract(contractId,1).expiry                 = expiry;
obj.Contract(contractId,1).description            = descrption;
obj.Contract(contractId,1).secType                = secType;
%             fields = fieldnames(contractDetails);
%             for i=1:numel(fields)
%                 obj.Contract(contractId,1).(fields{i}) = contractDetails.(fields{i});
%             end
%             obj.Contract(contractId,1).contractDetails        = contractDetails;
%获取localSymbol信息，得到tickerId, multiplier
obj.MarketData(contractId,1) = BaseMarketData;
disp([datestr(now,'HH:MM:SS'),'---Contract ',num2str(contractId),' ',localSymbol,' 添加成功.---'])
end