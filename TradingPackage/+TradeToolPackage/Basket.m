classdef Basket < handle
    properties
        CreateTime    %篮子创建时间
        BasketID      %篮子编号
        Ticker        %代码
        Exchange      %交易所
        OrderType     %Buy,Sell,BuyCover,SellCover,BuyCoverYesterday,SellCoverYesterday,BuyCoverToday,SellCoverToday
        Quantity      %数量
        Symbol        %投保标志(投机，套保，套利)
        RoundTime=2;  %轮询时间(秒)
        Round=10;     %轮询次数
        Expiration    %期权到期日
        Strike        %期权行权价
    end
end