% run F_UpdateBaseFactors
% run F_UpdateAdvFactors
run ConcatFactors
addpath F:\DataHub\LTFactorModel\Data

% 策略思路，每一年训练一次PCA和预测模型，训练使用数据周期为两年，然后用下一年交易
% 所有FactorData已经做了滞后一期处理
% FactorReturn为下一期的Return
load CodeMap
trainPeriod = 500;  % in sample : days
testPeriod  = 250;  % out of sample : days

numTrain = 1;
position = zeros(numel(TradeDay));
for iProduct=1:numel(CodeMap)
    for iTradeDay = trainPeriod:numel(TradeDay)
        % 训练之前的数据
    end
end