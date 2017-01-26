classdef BaseTimeLog
    %记录各个部分更新的时间（全部为yyyy-mm-dd HH:MM:SS）
    properties
        Sys
        Order
        OrderDraft
        Contract
        MarketData
        Trade
        Position
        Account
    end
end