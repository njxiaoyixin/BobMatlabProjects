classdef BaseTrade
    %交易记录表
    properties
        orderId
        localSymbol
        isBuy
        isOpen
        thisTradeVolume
        thisTradePrice
        tradeTime
        other
    end
end