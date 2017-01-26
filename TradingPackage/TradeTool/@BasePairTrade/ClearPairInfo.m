function ClearPairInfo(obj,pairContractId)
    if nargin <2
        pairContractId = 1:numel(obj.PairContract);
    end
    obj.PairContract(pairContractId) = [];
end