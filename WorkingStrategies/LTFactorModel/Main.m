% run F_UpdateBaseFactors
% run F_UpdateAdvFactors
run ConcatFactors
addpath F:\DataHub\LTFactorModel\Data

% ����˼·��ÿһ��ѵ��һ��PCA��Ԥ��ģ�ͣ�ѵ��ʹ����������Ϊ���꣬Ȼ������һ�꽻��
% ����FactorData�Ѿ������ͺ�һ�ڴ���
% FactorReturnΪ��һ�ڵ�Return
load CodeMap
trainPeriod = 500;  % in sample : days
testPeriod  = 250;  % out of sample : days

numTrain = 1;
position = zeros(numel(TradeDay));
for iProduct=1:numel(CodeMap)
    for iTradeDay = trainPeriod:numel(TradeDay)
        % ѵ��֮ǰ������
    end
end