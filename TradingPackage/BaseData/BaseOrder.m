classdef BaseOrder
    properties
        orderId                % 订单编号
        orderSysId             % 系统Id代号
        localSymbol@char       % 具有唯一性的ticker
        isBuy@logical          % 是否是买单
        isOpen@logical         % 是否是开仓（只适用于CTP）
        volume                 % 挂单量
        price@double           % 挂单价格
        tradedVolume           % 成交量
        lastFillPrice@double   % 最新成交的价格
        avgTradePrice@double   % 平均成交价
        orderStatus            % 订单状态号
        statusMsg@char         % 订单状态信息
        insertTime             % 订单添加时间
        updateTime             % 订单更新时间
        other                  % 其余信息（包含IB Order等）
        % IB Order
    end
    
    methods
        function obj = BaseOrder
            obj.orderId=0;
            obj.tradedVolume=0;
            obj.lastFillPrice=0;
            obj.avgTradePrice=0;
            obj.statusMsg = '';
            obj.insertTime = datestr(now,31);
            obj.updateTime = datestr(now,31);
        end
    end
end