classdef CTP_Drive < BaseTradeDrive
    properties
        Listeners
    end
    properties(Constant,Hidden)
        Error_List     = {'�Ҳ�����Լ','�������ܾ�','��λ����','�µ�ʧ��','�ֶ�����','�ʽ���','ƽ���������ֲ���','δ����','������δȷ��'};
        Sub_Error_List = {'��λ����','�ʽ���'};
        Fill_List      = {'ȫ���ɽ�'};
        Cancel_List    = {'�ѳ���'};
        InProcess_List = {'δ�ɽ�'};
        Pending_List   = {'���ڷ���'};
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
%                 obj.Broker    = '���Ž�Ͷ';
%                 obj.Username  = '047328';
%                 obj.Password  = '10950829';
        end
    end
    
    methods %��ӵĺ���
        RefreshPosition(obj)%ˢ�³ֲ�
        RegisterAllEvents(obj)%���������¼�������OnMarketData��GetMarketData�ж��ģ�
    end
    
    methods(Access = protected) %���еĻص�������˵������һЩĬ��Ϊ�պ���ʹ��ʱ��Ҫ���أ�
        funOnInitFinished(obj,varargin)
        funOnMDConnected(obj,varargin)
        funOnMDDisconnected(obj,varargin)
        funOnTradeConnected(obj,varargin)
        funOnTradeDisconnected(obj,varargin)
        funOnOrderCanceled(obj,varargin)
        funOnOrderActionFailed(obj,varargin)
        funOnOrderFinished(obj,varargin)
        funOnMarketData(obj,varargin)  % �����鷢���仯ʱ�Ĳ���
        funOnOrder(obj,varargin)        % ������״̬�����仯ʱ
        funOnAccount(obj,varargin)      % ���˻���Ϣ�����仯ʱ
        funOnPosition(obj,varargin)     % ���ֲ���Ϣ�����仯ʱ
        funOnTrade(obj,varargin)        % ��������ɵĶ��������仯ʱ
    end
end