function VRValue=VR(Price,Volume,Length)
%--------------------此函数用来计算VR指标(成交量比率指标)------------------
%----------------------------------编写者--------------------------------
%Lian Xiangbin(连长,785674410@qq.com),DUFE,2014
%----------------------------------参考----------------------------------
%[1]姜金胜.指标精萃：经典技术指标精解与妙用.东华大学出版社,2004年01月第1版
%[2]来自网络.24个基本指标精粹讲解
%[3]来自网络.学会利用关键技术指标
%[4]同花顺.VR指标算法
%----------------------------------简介----------------------------------
%VR指标又叫成交率比率指标、数量指标或容量指标，其英文全称为“Volume Ratio”，
%是重点研究量与价格间的关系的一种短期技术分析工具。VR指标是以研究证券量与价格
%之间的关系为手段的技术指标，其理论基础是“量价理论”和“反市场操作理论”。VR
%指标认为，由于量先价行、量涨价增、量跌价缩、量价同步、量价背离等成交量的基本
%原则在市场上恒久不变，因此，观察上涨与下跌的成交量变化，可作为研判行情的依据。
%同时，VR指标又认为，当市场上人气开始凝聚，价格刚开始上涨和在上涨途中的时候，
%投资者应顺势操作，而当市场上人气极度旺盛或极度悲观，价格暴涨暴跌时候，聪明的
%投资者应果断离场或进场，因此，反市场操作也是VR指标所显示的一项功能。 一般而
%言，低价区和高价区出现的买卖盘行为均可以通过成交量表现出来，因此。VR指标又带
%有超买超卖的研判功能。同时VR指标是用上涨时期的量除以下跌时期的量，因此，VR指
%标又带有一种相对强弱概念。总之，VR指标可以通过研判资金的供需及买卖气势的强弱、
%设定超买超卖的标准，为投资者确定合理、及时的买卖时机提供正确的参考。
%----------------------------------基本用法------------------------------
%1)低价区区域 
%VR值介于40—70区间时，为低价区域，表明证券的买卖盘稀少，人气比较涣散，但有
%的证券的投资价值可能已经凸现，投资者可以开始少量建仓。 
%2)安全区域 
%VR值介于80—150区间时，为安全区域，表明证券的买卖盘开始增多，人气开始积聚，
%投资者可以持有待涨或加大建仓量。 
%3)获利区域 
%VR值介于160—450区间时，为获利区域，表明证券在强大的买盘的推动下，节节上
%升，投资者应该将大部分获利比较丰厚的筹码及时地获利了结。 
%4)警戒区域 
%VR值介于450以上的区间时，为警戒区域，表明价格的上涨已经出现超买的现象，市
%场的后续资金很难跟上，价格可能随时出现一轮比较大的下跌行情，投资者应果断地
%卖出证券，持币观望 
%更多用法，请见参考
%----------------------------------调用函数------------------------------
%VRValue=VR(Price,Volume,Length)
%----------------------------------参数----------------------------------
%Price-判断上涨或下跌时的价格，可用Open、High、Low或Close，常用Close
%Volume-成交量
%Length-计算时所考虑的周期，常用26个Bar
%----------------------------------输出----------------------------------
%VRValue-成交量比率指标

VRValue=zeros(length(Price),1);
Diff=zeros(length(Price),1);
Diff(2:end)=Price(2:end)-Price(1:end-1);%价格差
for i=1:length(Price)
    if i<Length
        Temp=Volume(1:i);
        VRValue(i)=(sum(Temp(Diff(1:i)>0))+0*sum(Temp(Diff(1:i)==0)))...
            /(sum(Temp(Diff(1:i)<0))+0.5*sum(Temp(Diff(1:i)==0)))*100;        
    end
    if i>=Length
        Temp=Volume(i-Length+1:i);
        VRValue(i)=(sum(Temp(Diff(i-Length+1:i)>0))+0.5*sum(Temp(Diff(i-...
           Length+1:i)==0)))/(sum(Temp(Diff(i-Length+1:i)<0))+0.5*sum(...
           Temp(Diff(i-Length+1:i)==0)))*100;
    end
end




end

