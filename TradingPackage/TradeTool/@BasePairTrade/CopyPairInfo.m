function newPairContractId=CopyPairInfo(obj,pairContractId)  % 复制某个PairContract的信息
    if numel(obj.PairContract) < pairContractId
        warning('Invalid pairContractId!')
        return
    end
    newPairContractId = numel(obj.PairContract)+1;
    obj.PairContract(newPairContractId) = obj.PairContract(pairContractId);
end