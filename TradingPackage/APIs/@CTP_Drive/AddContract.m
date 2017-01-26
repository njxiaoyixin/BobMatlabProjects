function contractId = AddContract(obj,contractInfo)
if ~obj.SystemSwitch.InitFinished
    disp('Please wait for CTP initialization to be completed before making a move...')
    contractId = [];
    return
end

if ~isstruct(contractInfo) && ischar(contractInfo)  % 如果输入的是代码
    thisContractInfo.localSymbol = contractInfo;
    contractInfo = thisContractInfo;
elseif strcmpi(class(contractInfo),'BaseContract')  % 如果输入的是BaseContract
    contractInfo = get(contractInfo);
end
%避免添加localSymbol重复的Contract
if any(strcmpi(contractInfo.localSymbol(1:2),{'IF','IH','IC'} ))
    localSymbol                  = upper(contractInfo.localSymbol);
else
    localSymbol                  = lower(contractInfo.localSymbol);
end
secType = 'FUT';
contractId                       = numel(obj.Contract)+1;
if numel(obj.Contract)>0
    currentLocalSymbol = arrayfun(@(x)obj.Contract(x).localSymbol,1:numel(obj.Contract),'UniformOutput',false);
    thisContractId = find(strcmpi(currentLocalSymbol,localSymbol),1);
    if ~isempty(thisContractId)
        contractId = thisContractId;
    end
end
if ~isfield(contractInfo,'multiplier') || ~isfield(contractInfo,'minTick')
    [contractDetails.multiplier,contractDetails.minTick] = GetInstrumentInfo(obj.LoginId,localSymbol);%获得一个合约的乘数和最小价格变动单位
else
    contractDetails.multiplier = contractInfo.multiplier;
    contractDetails.minTick    = contractInfo.minTick;
end
if ~isfield(contractInfo,'marginRate') || ~isfield(contractInfo,'expiry')
    [contractDetails.marginRate,contractDetails.expiry]  = GetMarginRate(obj.LoginId,localSymbol);
else
    contractDetails.marginRate = contractInfo.marginRate;
    contractDetails.expiry    = contractInfo.expiry;
end
obj.Contract(contractId,1).insertTime             = datestr(now,31);
obj.Contract(contractId,1).localSymbol            = localSymbol;
obj.Contract(contractId,1).symbol                 = localSymbol(1:end-4);
obj.Contract(contractId,1).expiry                 = localSymbol(end-3:end);
obj.Contract(contractId,1).minTick                = contractDetails.minTick;
obj.Contract(contractId,1).multiplier             = contractDetails.multiplier;
obj.Contract(contractId,1).secType                = secType;
fields = fieldnames(contractDetails);
for i=1:numel(fields)
    obj.Contract(contractId,1).other.contractDetails.(fields{i}) = contractDetails.(fields{i});
end

obj.MarketData(contractId,1) = BaseMarketData;
%             obj.Contract(contractId,1).contractDetails        = contractDetails;
%获取localSymbol信息，得到tickerId, multiplier
disp([datestr(now,'HH:MM:SS'),'---Contract ',num2str(contractId),' ',localSymbol,' 添加成功.---'])
end