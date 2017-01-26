function UpdateAdvFactors()
addpath(genpath(pwd))
% ���ڼ���fundaAdvFactors�Լ�techAdvFactors������baseFactors����һЩ������factors
% ����fundaAdvFactors

%% Calculate techAdvFactors
load CodeMap
load techBaseFactors
products        = {CodeMap.product};
techAdvFactors = struct();
for product = 1:numel(products)
    for factorName = fieldnames(sTechFactors.AdvancedFactors)
        switch upper(factorName)
            case upper(log_MA5d)
                techAdvFactors.(product) = MA(TechBaseFactors.(product).Close,5);
            case
                
            otherwise
                
        end
        
    end
end


end