classdef HFtrader < trader
    %用作高频交易测试的trader,采取flow形式
    %即将数据以一个flow的形式输入，边输入边判断信号，边进行交易，并记录和统计交易
    %即交易和统计不分开（节省算法复杂度）
    properties
        DailySR         % 日夏普比率
        DailyMDD        % 日最大回撤
    end
    
    methods
        function DailyClear(obj,Date,SettlePrice)
            % 输入结算价，总结当日交易结果
            % 当日交易结果包括：日收益率、日夏普比率、日内最大回撤
            
            %将ClearBook中今日的交易进行筛选
            Ind = find(obj.ClearBook.Time)
            
            
            if nargin <3
                ThisUnrealized = obj.CurrentStatus.Position*(SettlePrice-obj.CurrentStatus.OpenPrice);
            else
                ThisUnrealized = obj.CurrentStatus.UnrealizedRet;
            end
            
        end
        
        function PlotResult(obj)
           %画出三个图：日资金曲线图，日夏普曲线图，日最大回撤图
        end
    end
    
    methods(Static = true)
        function DailySRCalc(ClearBook,Date)
            % 近似算法
        end
    end
end