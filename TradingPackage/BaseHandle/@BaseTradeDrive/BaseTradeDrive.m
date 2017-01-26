classdef BaseTradeDrive < BaseQuoteDrive
    properties(SetObservable,AbortSet)
        OrderDraft@BaseOrderDraft       % 拟发送的Order
        Order@BaseOrder                 % 当前存在的Order信息
        Trade@BaseTrade                 % 所有已完成的交易
        Position@BasePosition           % 当前持仓的信息
        Account=BaseAccount             % 当前账户信息
    end
    
    properties(Constant,Abstract)
        Error_List %需要立即停止交易的Error List
        Sub_Error_List %可以不用立即停止交易的Error_List
        Fill_List %表示成交完成的信号List
        Cancel_List %表示撤单的描述
        InProcess_List %表示订单已发出，执行过程中的List
        Pending_List % 表示订单正在发出过程中的List
    end
    methods %交易模块
        function obj=BaseTradeDrive
%             obj.SystemSwitch.isTrade = 1;
        end
        ResumeTrade(obj)
        PauseTrade(obj)
        draftId = AddOrder(obj,contractId,orderInfo,orderStrategyParam)
        [cancelId,remark] = CancelOrderDraft(obj,draftId)
        Position = GetPosition(obj,ContractId)%查询持仓
        Order = GetOrder(obj,OrderId)  %查询现在所有的open order
        Trade = GetTrade(obj,ContractId)%查询成交记录
        Account = GetAccount(obj)%查询账户信息
        [cancelId] = CancelOrder(obj,orderId)%撤单
        CancelAllOrder(obj)
        BaseTransmit(obj,OrderInfo,varargin)
        TransmitOrder(obj,draftId,varargin)
        Fcn_PlaceOrder(obj,draftId,varargin)
        Clear(obj,localSymbol)
        AllClear(obj,varargin)
        StopSystem(obj) %强制撤单，停止下单，并退出登陆
    end
    
    methods(Access = protected) % Callbacks
        CallbackOnOrderChange(obj,iOrder,varargin)
        funOnOrder(obj,varargin)       % 当订单状态发生变化时
        funOnAccount(obj,varargin)      % 当账户信息发生变化时
        funOnPosition(obj,varargin)    %当持仓信息发生变化时
        funOnTrade(obj,varargin)        %当交易完成的订单发生变化时
    end
end