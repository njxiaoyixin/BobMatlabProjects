classdef BaseRiskEngine
    %需要监控的风控指标
    % 1. 保证金不能超过限制
    % 2. 持有仓位不能超过限制张数或者股数
    % 3. 单合约撤单数量不能超过限制
    % 4. 股票的持仓比例不能超过限制
    % 5. 开仓数量不能超过限制
    % 6. 日内实现亏损不能超过限制
    % 7. 持仓亏损不能超过限制
    
    properties%风控指标
        MaxMargin                    % 最大保证金
        MaxPosition @ BasePosition   % 最大仓位
        MaxContractCancel            % 最大撤单
        MaxShare                     % 最大股份比例
        MaxOpenPosition              % 最大开仓数量
        MaxRealizedLoss              % 最大实现亏损
        MaxUnrealizedLoss            % 最大浮动亏损
    end
    properties(SetAccess = private)
        Listener
    end
    methods%计算风控指标并进行提示
        function StartRiskEngine(obj)
            
        end
        function StopRiskEngine(obj)
            
        end
        CalcContractCancel(obj)
    end
end