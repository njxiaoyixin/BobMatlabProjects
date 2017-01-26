classdef CTP_Drive < BaseTradeDrive
    properties
        Listeners
    end
    properties(Constant,Hidden)
        Error_List     = {'找不到合约','报单被拒绝','仓位不足','下单失败','字段有误','资金不足','平仓量超过持仓量','未连接','结算结果未确认'};
        Sub_Error_List = {'仓位不足','资金不足'};
        Fill_List      = {'全部成交'};
        Cancel_List    = {'已撤单'};
        InProcess_List = {'未成交'};
        Pending_List   = {'正在发送'};
    end
    properties(Hidden)
        Broker
        AccountNumber
        Username
        Password
    end
    
    events
        
    end
    
    methods
        function obj=CTP_Drive
%                 obj.Broker    = '中信建投';
%                 obj.Username  = '047328';
%                 obj.Password  = '10950829';
        end
    end
    
    methods %添加的函数
        RefreshPosition(obj)%刷新持仓
        RegisterAllEvents(obj)%订阅所有事件（除了OnMarketData在GetMarketData中订阅）
    end
    
    methods(Access = protected) %所有的回调函数及说明（有一些默认为空后续使用时需要重载）
        funOnInitFinished(obj,varargin)
        funOnMDConnected(obj,varargin)
        funOnMDDisconnected(obj,varargin)
        funOnTradeConnected(obj,varargin)
        funOnTradeDisconnected(obj,varargin)
        funOnOrderCanceled(obj,varargin)
        funOnOrderActionFailed(obj,varargin)
        funOnOrderFinished(obj,varargin)
        funOnMarketData(obj,varargin)  % 当行情发生变化时的操作
        funOnOrder(obj,varargin)        % 当订单状态发生变化时
        funOnAccount(obj,varargin)      % 当账户信息发生变化时
        funOnPosition(obj,varargin)     % 当持仓信息发生变化时
        funOnTrade(obj,varargin)        % 当交易完成的订单发生变化时
    end
end