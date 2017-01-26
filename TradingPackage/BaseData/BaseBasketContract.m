classdef BaseBasketContract
    properties
        contract@BaseContract;  %待交易的合约信息
        orderStrategy ='BOL';   % 篮子出价参数,BOL,BOP,BOC,FOK,FOA
        orderType               % Buy,Short,Sell,Cover
        quantity                % 数量
        priceShift   = 0;       % 出价参数（正数代表向对方盘口偏移）
        minSize                 % 最小手数
        minTick                 % 最小价格
        account                 % 交易通道,CTP,IBTWS...
        quote                   % 行情通道,CTP,IBTWS...
        mark         ='Spec';   % 投保标志
        underlying   =' ';      % 跟踪标的
        pollTime     = 5;       % 轮询时间(秒)
        pollNum      = 10;      % 轮询次数
        busyMode     = 'queue'; % 重复下单参数,queue,drop
        cancelAtEnd  = true;    % 轮询结束后是否撤单
    end
    
    methods
        %设置自检，看必须参数是否填写完毕
        function isOK=SelfCheck(obj)
            isOK=1;
            s=?BasePairContract;
            for i=1:numel(s.PropertyList)
                if isempty(obj.(s.PropertyList(i).Name))
                    isOK = 0;
                    disp(['PairContract Property ',s.PropertyList(i).Name,' is not Set!'])
                end
            end
        end
    end
end