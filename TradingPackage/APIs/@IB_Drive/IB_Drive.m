classdef IB_Drive < BaseTradeDrive
    properties(Constant,Hidden)
        Error_List     = {'APICancelled','Inactive'};
        Sub_Error_List = {'InSufficientFund'}; %��ʱû�з��ָ�����״̬
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
        GetPosition(obj,contractId)%��ѯ�ֲ�
        GetAccount(obj,AccountNumber)
        GetTrade(obj)%��ѯ�ɽ���¼
        GetOrder(obj,orderId,clientOnly)
    end
    methods(Access = protected)
        funOnConnectionClosed(obj,varargin)
        funOnMarketData(obj,varargin)  % �����鷢���仯ʱ�Ĳ���
        funOnOrder(obj,varargin)       % ������״̬�����仯ʱ
        funOnAccount(obj,varargin)      % ���˻���Ϣ�����仯ʱ
        funOnPosition(obj,varargin)    %���ֲ���Ϣ�����仯ʱ
        funOnTrade(obj,varargin)        %��������ɵĶ��������仯ʱ
    end
end