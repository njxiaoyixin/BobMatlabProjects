classdef IB_Drive < BaseTradeDrive
    properties(Constant,Hidden)
        Error_List     = {'APICancelled','Inactive'};
        Sub_Error_List = {'InSufficientFund'}; %暂时没有发现该类型状态
        Fill_List      = {'Filled'};
        Cancel_List    = {'Cancelled'};
        InProcess_List = {'Submitted'};
        Pending_List   = {'PendingSubmit'};
    end
    properties(Hidden)
        ip
        account
        port
        clientId
        TickerId
    end
    
    methods
        function obj=IB_Drive()
        end
        
        RegisterAllEvents(obj)
        UnRegisterallEvents(obj)
        GetPosition(obj,contractId)%查询持仓
        GetAccount(obj,AccountNumber)
        GetTrade(obj)%查询成交记录
        GetOrder(obj,orderId,clientOnly)
    end
    methods(Access = protected)
        funOnConnectionClosed(obj,varargin)
        funOnMarketData(obj,varargin)  % 当行情发生变化时的操作
        funOnOrder(obj,varargin)       % 当订单状态发生变化时
        funOnAccount(obj,varargin)      % 当账户信息发生变化时
        funOnPosition(obj,varargin)    %当持仓信息发生变化时
        funOnTrade(obj,varargin)        %当交易完成的订单发生变化时
    end
end