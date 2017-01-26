function pairContractId = AddPairContract(obj,pairContractInfo)
    pairContractId = numel(obj.PairContract)+1;
    obj.PairContract(pairContractId) = BasePairContract;
    fields = fieldnames(pairContractInfo);
    for i=1:numel(fields)
        obj.PairContract(pairContractId).(fields{i}) = pairContractInfo.(fields{i});
    end
end