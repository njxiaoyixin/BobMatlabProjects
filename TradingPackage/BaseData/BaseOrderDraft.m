classdef BaseOrderDraft
    properties
        insertTime
        fillTime
        updateTime
        sysId
        contractId
        localSymbol@char
        orderId %与OrderDraft关联的当前的OrderId
        allOrderId % 所有与本OrderDraft关联的orderId
        action@char
        orderStrategy@char
        orderType@char
        isBuy@logical
        totalQuantity
        totalFillQuantity
        avgTradePrice
        param
        status
        remark@char
        targetPrice
        impactCost
        orderInfo
        other
    end
    
    properties(Hidden)
        pollNum
        pollTimer
        cancelNum
        
        fillQuantity
        histFillQuantity
        histTradePrice
        busy
    end
    
    methods
        function obj=BaseOrderDraft
            obj.orderId            = 0;
            obj.totalQuantity      = 1;
            obj.totalFillQuantity  = 0;
            obj.avgTradePrice      = 0;
            obj.pollNum            = 0;
            obj.cancelNum          = 0;
            obj.allOrderId         = [];
            obj.fillQuantity       = 0;
            obj.fillQuantity       = 0;
            obj.histFillQuantity   = 0;
            obj.histTradePrice     = 0;
            obj.impactCost         = 0;
            obj.targetPrice        = 0;
            obj.insertTime         = datestr(now,31);
            obj.updateTime         = datestr(now,31);
        end
    end
end