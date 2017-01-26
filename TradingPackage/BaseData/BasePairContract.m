classdef BasePairContract < handle
    properties(SetAccess = private)
        insertTime
    end
    
    properties(SetObservable,AbortSet)  %配对交易交易单个合约基本信息
        contract@BaseContract      % 合约信息
        pairStrategy               % 配对出价参数(Pair_MKT,Pair_wait_limit,pair_wait_rel)
        side@char                  % Buy,Short,Sell,Cover
        quantity                   % 数量
        priceMultiplier            % 价格系数
        priceShift                 % 出价参数（正数代表向对方盘口偏移）
        minSize                    % 最小手数
        minTick                    % 最小价格
        reorderSize                % 重挂范围（当价格变动超过此数字时，重新进行挂单）
        account@char               % 交易通道
        quote@char                 % 行情通道
        mark@char                  % 投保标志
        underlying@BaseContract    % 跟踪标的
    end
    
    methods
        
        function obj = BasePairContract()
            obj.insertTime      = datestr(now,31);
            obj.pairStrategy    = 'PAIR_MKT';
            obj.side            = '';
            obj.quantity        = 0 ;
            obj.priceMultiplier = 1;    % 用于
            obj.priceShift      = 0;    % 出价时的偏移
            obj.minSize         = 1;    % 最小挂单数
            obj.minTick         = 0.01; % 最小价格
            obj.reorderSize     = 0.01; 
            obj.account         = '';
            obj.quote           = '';
            obj.mark            = '';
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