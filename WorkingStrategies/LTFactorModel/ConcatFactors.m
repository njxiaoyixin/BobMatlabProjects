function [FactorData,FactorNames,FactorReturn] = F_ConcatFactors()
% �����е�FundaFactor��TechFactor���ӳ�Ϊ���󣬲����������Return
% ��������б�
% Load Config
addpath(genpath(pwd))
Config       = xml_read('Config.xml');
DataDir      = Config.DataDir;

load(fullfile(DataDir,'Data','CodeMap'))
load(fullfile(DataDir,'Data','PxActive'))

NumDay = 1; % ʱ�����ڣ�Numday��

products = {CodeMap.product};
% ����Factors
% FactorTypes = {'fundaBaseFactors','fundaAdvFactors','techBaseFactors','techAdvFactors'};
FactorTypes = {'fundaBaseFactors','techBaseFactors'};
for thisFactorType = FactorTypes
    load(fullfile(DataDir,'Data',thisFactorType{:}))
end

FactorReturn = nan(numel(TradeDay.LF),numel(products));
FactorReturn_Daily = nan(numel(TradeDay.Daily),numel(products));
for iProduct = 1:numel(products)
    thisProduct = products{iProduct};
    FactorNames.(thisProduct) = {};
    FactorData.(thisProduct)  = [];
    for thisFactorType = FactorTypes
        thisFactorData   = eval([thisFactorType{:},'(',num2str(iProduct),').Factor']);
        thisFactorNames  = eval([thisFactorType{:},'(',num2str(iProduct),').FactorName']);
        FactorNames.(thisProduct) = [FactorNames.(thisProduct),thisFactorNames];
        FactorData.(thisProduct)  = [FactorData.(thisProduct),thisFactorData];
    end
    % ���������ݿ�ֵȫ������Ϊ0
    FactorData.(thisProduct)(isnan(FactorData.(thisProduct))) = 0; 
    % ���������
    Px = nan(numel(TradeDay.LF),1);
    if isempty(PxActive_LF.(thisProduct))
        continue
    end
    for iTradeDay=1:numel(TradeDay.LF)
        idx = floor(TradeDay.LF(iTradeDay)) == floor(PxActive_LF.(thisProduct).Time);
        if any(idx)
            Px(iTradeDay) = PxActive_LF.(thisProduct).Close(idx);
        end
    end
     priceReturn = Fcn_CalcReturn(Px,NumDay);
     % ��Return��ǰһ��
     FactorReturn(:,iProduct) = [priceReturn(2:end);nan];
     
     % ������return���У����ڼ���ֲ�����
     Px_Daily = nan(numel(TradeDay.Daily),1);
     if isempty(PxActive_Align.(thisProduct))
         FactorReturn_Daily(:,iProduct) = Px_Daily;
         continue
     end
     for iTradeDay=1:numel(TradeDay.Daily)
         idx = floor(TradeDay.Daily(iTradeDay)) == floor(PxActive_Align.(thisProduct).Time);
         if any(idx)
             Px_Daily(iTradeDay) = PxActive_Align.(thisProduct).Close(idx);
         end
     end
     priceReturn_Daily = Fcn_CalcReturn(Px_Daily,NumDay);
     % ��Return��ǰһ��
     FactorReturn_Daily(:,iProduct) = [priceReturn_Daily(2:end);nan];
end
save(fullfile(DataDir,'Data\Factors.mat'),'FactorData','FactorNames','FactorReturn','FactorReturn_Daily')
end

function Returns = Fcn_CalcReturn(BaseClose,NumDay)
if nargin<2
    NumDay = 1;
end
BaseReturns   = zeros(size(BaseClose));
TempBaseClose = zeros(1,numel(BaseClose(1,:)));
for i=1:numel(BaseClose(:,1))
    for j=1:numel(BaseClose(1,:))
        if isnan(BaseClose(i,j)) || BaseClose(i,j)==0
            BaseReturns(i,j) = nan;
        elseif i==1 || TempBaseClose(j)==0
            BaseReturns(i,j) = 0;
            TempBaseClose(j) = BaseClose(i,j);
        else
            BaseReturns(i,j) = BaseClose(i,j)./TempBaseClose(j)-1;
            TempBaseClose(j) = BaseClose(i,j);
        end
    end
end
Returns = Fcn_CalcReturn_NDay(BaseReturns,NumDay);
end

function Returns = Fcn_CalcReturn_NDay(BaseReturns,NumDay)
if nargin < 2 || NumDay==1
    Returns = BaseReturns;
    return
end
Returns = zeros(size(BaseReturns));
for k=1:NumDay
    TempBaseReturns = BaseReturns(1+k-1:end-NumDay+k,:);
    TempBaseReturns(isnan(TempBaseReturns)) = 0;
    Returns(NumDay:end,:) = Returns(NumDay:end,:)+TempBaseReturns;
end
end