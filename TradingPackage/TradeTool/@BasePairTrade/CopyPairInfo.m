function newPairContractId=CopyPairInfo(obj,pairContractId)  % ����ĳ��PairContract����Ϣ
    if numel(obj.PairContract) < pairContractId
        warning('Invalid pairContractId!')
        return
    end
    newPairContractId = numel(obj.PairContract)+1;
    obj.PairContract(newPairContractId) = obj.PairContract(pairContractId);
end