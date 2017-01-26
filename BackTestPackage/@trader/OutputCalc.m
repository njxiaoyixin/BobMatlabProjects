function OutputCalc(obj)
k=1;
for i=1:numel(obj.DateVec)
    if obj.DailyRetVec(i)~=0
        k=i;
        break
    end
end
obj.Output.DaysNum=length(obj.DateVec)-k+1;
obj.Output.InitialFund = obj.InitialFund;
if(obj.Output.DaysNum>0)
    obj.Output.TotalGain = obj.DailyAssetVec(end)-obj.InitialFund;
    obj.Output.NetRet=sum(obj.DailyRetVec);
    obj.Output.AnnualRet=obj.Annualize(obj.Output.NetRet,obj.Output.DaysNum);
    obj.Output.RetPerDeal=obj.Output.NetRet/length(obj.CBook.RetVec);
    obj.Output.StdbyDay=std(obj.DailyRetVec(k:end));
    obj.Output.EarningVar=std(obj.CBook.RetVec)^2;
    obj.Output.DealNum=length(obj.CBook.RetVec);
    obj.Output.WinNum=0;
    obj.Output.LossNum=0;
    obj.Output.TotalWin=0;
    obj.Output.TotalLoss=0;
    for i=1:length(obj.CBook.RetVec)
        if obj.CBook.RetVec(i)>0
            obj.Output.WinNum=obj.Output.WinNum+1;
            obj.Output.TotalWin=obj.Output.TotalWin+obj.CBook.RetVec(i);
        elseif obj.CBook.RetVec(i)<0
            obj.Output.LossNum=obj.Output.LossNum+1;
            obj.Output.TotalLoss=obj.Output.TotalLoss+obj.CBook.RetVec(i);
        end
    end
    obj.Output.WinRate=obj.Output.WinNum/obj.Output.DealNum;
    obj.Output.SRbyTrade=SharpeRatio(obj.CBook.RetVec);
    obj.Output.SRbyDay=SharpeRatio(obj.DailyRetVec(k:end));
    obj.Output.AnnualSR=obj.Annualize(obj.Output.SRbyDay,obj.Output.DaysNum,0);
    obj.Output.AverageWin=obj.Output.TotalWin/obj.Output.WinNum;
    obj.Output.AverageLoss=obj.Output.TotalLoss/obj.Output.LossNum;
    if length(obj.DailyRetVec)>1
        obj.Output.MaxDrawDown=maxdrawdown(cumsum(...
            obj.DailyRetVec),'arithmetic');
    else
        obj.Output.MaxDrawDown=0;
    end
end
end