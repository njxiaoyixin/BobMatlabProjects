function CombTrader=plus(obj1,obj2)
%Note：The two traders must be under the same currency
CombTrader = trader(obj1.TradeCost+obj2.TradeCost,obj1.Fx(1)*obj1.InitialFund+obj2.Fx(1)*obj2.InitialFund);
ThisTimeSeries.TimeVec=union(obj1.TimeVec,obj2.TimeVec);
CombTrader.PreSetTimeSeries(ThisTimeSeries)
% 合并DateVec 和 DailyGainVec, DailyAssetVec, DailyFundChangeVec
CombTrader.DateVec            = union(obj1.DateVec,obj2.DateVec);
CombTrader.DailyAssetVec      = zeros(numel(CombTrader.DateVec),1);
CombTrader.DailyGainVec       = zeros(numel(CombTrader.DateVec),1);
CombTrader.DailyFundChangeVec = zeros(numel(CombTrader.DateVec),1);
CombTrader.DailyFx            = ones(numel(CombTrader.DateVec),1);
for i=1:numel(CombTrader.DateVec)
    Idx1                  = find(obj1.DateVec==CombTrader.DateVec(i),1);
    Idx2                  = find(obj2.DateVec==CombTrader.DateVec(i),1);
    ThisFx1               = obj1.DailyFx(Idx1);
    ThisFx2               = obj2.DailyFx(Idx2);
    ThisDailyAsset1       = ThisFx1*obj1.DailyAssetVec(Idx1);
    ThisDailyAsset2       = ThisFx2*obj2.DailyAssetVec(Idx2);
    ThisDailyGain1        = ThisFx1*obj1.DailyGainVec(Idx1);
    ThisDailyGain2        = ThisFx2*obj2.DailyGainVec(Idx2);
    ThisDailyFundChange1  = ThisFx1*obj1.DailyFundChangeVec(Idx1);
    ThisDailyFundChange2  = ThisFx2*obj2.DailyFundChangeVec(Idx2);
    CombTrader.DailyAssetVec(i)=CombTrader.DailyAssetVec(i)+...
        EmptyorZero(ThisDailyAsset1)+EmptyorZero(ThisDailyAsset2);
    CombTrader.DailyGainVec(i)=CombTrader.DailyGainVec(i)+...
        EmptyorZero(ThisDailyGain1)+EmptyorZero(ThisDailyGain2);
    CombTrader.DailyFundChangeVec(i)=CombTrader.DailyFundChangeVec(i)+...
        EmptyorZero(ThisDailyFundChange1)+EmptyorZero(ThisDailyFundChange2);
end
%计算CombTrader.DailyRetVec防止前一天的市值为0，出现相除出现nan的情况
DailyAssetVec_Lag1=[CombTrader.InitialFund;CombTrader.DailyAssetVec(1:end-1)];
CombTrader.DailyRetVec = zeros(size(CombTrader.DateVec));
for i=1:numel(CombTrader.DailyAssetVec)
    if DailyAssetVec_Lag1(i)~=0
        CombTrader.DailyRetVec(i) = (CombTrader.DailyAssetVec(i)-CombTrader.DailyFundChangeVec(i)-...
            DailyAssetVec_Lag1(i))/DailyAssetVec_Lag1(i);
    end
end

%CBook
CombTrader.CBook.TimeVec=union(obj1.CBook.TimeVec,obj2.CBook.TimeVec);
CombTrader.CBook.GainVec=zeros(length(CombTrader.CBook.TimeVec),1);
CombTrader.CBook.RetVec=zeros(length(CombTrader.CBook.TimeVec),1);
%将两个交易的同一笔交易合并
for i=1:length(CombTrader.CBook.TimeVec)
    Idx1           = find(obj1.CBook.TimeVec==CombTrader.CBook.TimeVec(i),1);
    Idx2           = find(obj2.CBook.TimeVec==CombTrader.CBook.TimeVec(i),1);
    ThisFx1        = obj1.Fx(obj1.TimeVec==CombTrader.CBook.TimeVec(i));
    ThisFx2        = obj2.Fx(obj2.TimeVec==CombTrader.CBook.TimeVec(i));
    ThisGainVec1   = ThisFx1*obj1.CBook.GainVec(Idx1);
    ThisGainVec2   = ThisFx2*obj2.CBook.GainVec(Idx2);
    Cost1          = ThisFx1*obj1.CBook.CostVec(Idx1);
    Cost2          = ThisFx2*obj2.CBook.CostVec(Idx2);
    CombTrader.CBook.GainVec(i)=CombTrader.CBook.GainVec(i)+...
        (EmptyorZero(ThisGainVec1)+EmptyorZero(ThisGainVec2));
    CombTrader.CBook.CostVec(i) = EmptyorZero(Cost1)+EmptyorZero(Cost2);
    if CombTrader.CBook.CostVec(i)~=0
        CombTrader.CBook.RetVec(i)=CombTrader.CBook.GainVec(i)/CombTrader.CBook.CostVec(i);
    end
end
% To be continued....PositionVec, AssetVec, TBook....
end