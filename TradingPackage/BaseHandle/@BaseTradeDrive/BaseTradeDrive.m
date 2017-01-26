classdef BaseTradeDrive < BaseQuoteDrive
    properties(SetObservable,AbortSet)
        OrderDraft@BaseOrderDraft       % �ⷢ�͵�Order
        Order@BaseOrder                 % ��ǰ���ڵ�Order��Ϣ
        Trade@BaseTrade                 % ��������ɵĽ���
        Position@BasePosition           % ��ǰ�ֲֵ���Ϣ
        Account=BaseAccount             % ��ǰ�˻���Ϣ
    end
    
    properties(Constant,Abstract)
        Error_List %��Ҫ����ֹͣ���׵�Error List
        Sub_Error_List %���Բ�������ֹͣ���׵�Error_List
        Fill_List %��ʾ�ɽ���ɵ��ź�List
        Cancel_List %��ʾ����������
        InProcess_List %��ʾ�����ѷ�����ִ�й����е�List
        Pending_List % ��ʾ�������ڷ��������е�List
    end
    methods %����ģ��
        function obj=BaseTradeDrive
%             obj.SystemSwitch.isTrade = 1;
        end
        ResumeTrade(obj)
        PauseTrade(obj)
        draftId = AddOrder(obj,contractId,orderInfo,orderStrategyParam)
        [cancelId,remark] = CancelOrderDraft(obj,draftId)
        Position = GetPosition(obj,ContractId)%��ѯ�ֲ�
        Order = GetOrder(obj,OrderId)  %��ѯ�������е�open order
        Trade = GetTrade(obj,ContractId)%��ѯ�ɽ���¼
        Account = GetAccount(obj)%��ѯ�˻���Ϣ
        [cancelId] = CancelOrder(obj,orderId)%����
        CancelAllOrder(obj)
        BaseTransmit(obj,OrderInfo,varargin)
        TransmitOrder(obj,draftId,varargin)
        Fcn_PlaceOrder(obj,draftId,varargin)
        Clear(obj,localSymbol)
        AllClear(obj,varargin)
        StopSystem(obj) %ǿ�Ƴ�����ֹͣ�µ������˳���½
    end
    
    methods(Access = protected) % Callbacks
        CallbackOnOrderChange(obj,iOrder,varargin)
        funOnOrder(obj,varargin)       % ������״̬�����仯ʱ
        funOnAccount(obj,varargin)      % ���˻���Ϣ�����仯ʱ
        funOnPosition(obj,varargin)    %���ֲ���Ϣ�����仯ʱ
        funOnTrade(obj,varargin)        %��������ɵĶ��������仯ʱ
    end
end