function contractId = AddContract(obj,contractInfo)
if ~obj.SystemSwitch.InitFinished
    disp('Please wait for CTP initialization to be completed before making a move...')
    contractId = [];
    return
end

if ~isstruct(contractInfo) && ischar(contractInfo)  % ���������Ǵ���
    thisContractInfo.localSymbol = contractInfo;
    contractInfo = thisContractInfo;
elseif strcmpi(class(contractInfo),'BaseContract')  % ����������BaseContract
    contractInfo = get(contractInfo);
end
%�������localSymbol�ظ���Contract
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
    [contractDetails.multiplier,contractDetails.minTick] = GetInstrumentInfo(obj.LoginId,localSymbol);%���һ����Լ�ĳ�������С�۸�䶯��λ
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
%��ȡlocalSymbol��Ϣ���õ�tickerId, multiplier
disp([datestr(now,'HH:MM:SS'),'---Contract ',num2str(contractId),' ',localSymbol,' ��ӳɹ�.---'])
end