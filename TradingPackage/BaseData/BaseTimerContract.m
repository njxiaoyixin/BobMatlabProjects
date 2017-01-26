classdef BaseTimerContract
    properties(SetAccess = private)
        createTime
    end
    
    properties
        contract@BaseContract  % 合约信息
        orderStrategy='BOL';   % 出价参数,BOL,BOP,BOC,FOK,FOA
        orderType              % Buy,Short,Sell,Cover
        quantity               % 数量
        priceMultiplier =1;    % 价格系数
        priceShift   = 0;      % 出价参数（正数代表向对方盘口偏移）
        minSize                % 最小手数
        minTick                % 最小价格
        account                % 交易通道
        quote                  % 行情通道
        mark         ='Spec';  % 投保标志
        underlying   =' '      % 跟踪标的
        busyMode     = 'queue';% 订单排队模式:queue,drop
    end
    
    methods
        function obj = BaseTimerContract()
            obj.createTime = datestr(now,31);
        end
        
        %设置自检，看必须参数是否填写完毕
        function SelfCheck(obj)
            s=?BasePairContract;
            for i=1:numel(s.PropertyList)
                if isempty(obj.(s.PropertyList(i).Name))
                    disp(['PairContract Property ',s.PropertyList(i).Name,' is not Set!'])
                end
            end
        end
    end
end