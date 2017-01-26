classdef BaseMarketData < handle
    properties(SetObservable,AbortSet)
        bidSize
        bidPrice
        askPrice
        askSize
        lastPrice
        lastSize
        pctChange
        volume
        amount
        openInterest
        openPrice
        highestPrice
        lowestPrice
        upperLimitPrice
        lowerLimitPrice
        preSettlementPrice
        averagePrice
        preClose
        updateTime
        updateMilliSecond
        other
        %IB :
        % BidPrice,BidSize,AskPrice,AskSize,LastPrice,LastSize,Volume 
    end
end