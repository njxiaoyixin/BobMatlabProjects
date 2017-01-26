classdef BasePairTrade < BaseStrategy
    properties(SetObservable,AbortSet)
        PairContract@BasePairContract
        % 以下是配对交易相关参数
        PriceLadder @BasePriceLadder
    end
    
    events
        RelExecuted%被动腿成交，立即下单其余腿
    end
    
    methods
        function obj=BasePairTrade
            
        end
        pairContractId = AddPairContract(obj,pairContractInfo)
        ClearPairInfo(obj,pairContractId)  %清空PairContract的信息
        newPairContractId=CopyPairInfo(obj,pairContractId)  % 复制某个PairContract的信息
        ReqMktData(obj)
        
        StartTrade(obj,spread)  %以指定的Spread来下单pair交易，spread省略时默认以盘口下单
        StopTrade(obj)
        CancelOrder(obj)
        CoverDeficit(obj) %补平两边头寸
        % 下面两句用在上层系统，当把基本的配对交易功能实现后进行管理使用
        %         AddPairContractToDatabase(obj,pairContractInfo,pairName) %自建access数据库，储存配对交易信息
        %         pairContractInfo= ExtractPairContractFromDatabase(obj,pairName) %从自建access数据库配对交易信息
    end
    
    methods%callbacks
        funOnRelExecuted(obj) %当被动腿成交后触发，立即下单其余腿
    end
end