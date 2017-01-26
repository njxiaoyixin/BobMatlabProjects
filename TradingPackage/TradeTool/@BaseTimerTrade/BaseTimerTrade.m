classdef BaseTimerTrade<BaseStrategy
    %定时交易工具
    %初始设定为交易单产品
    %后续可升级为交易篮子和Pair
    properties(SetObservable,AbortSet)
        TimerContract @BaseTimerContract
    end
    
    methods
        
    end
    
    methods%callbacks
        
    end
    
end