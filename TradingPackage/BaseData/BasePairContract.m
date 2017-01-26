classdef BasePairContract < handle
    properties(SetAccess = private)
        insertTime
    end
    
    properties(SetObservable,AbortSet)  %��Խ��׽��׵�����Լ������Ϣ
        contract@BaseContract      % ��Լ��Ϣ
        pairStrategy               % ��Գ��۲���(Pair_MKT,Pair_wait_limit,pair_wait_rel)
        side@char                  % Buy,Short,Sell,Cover
        quantity                   % ����
        priceMultiplier            % �۸�ϵ��
        priceShift                 % ���۲���������������Է��̿�ƫ�ƣ�
        minSize                    % ��С����
        minTick                    % ��С�۸�
        reorderSize                % �عҷ�Χ�����۸�䶯����������ʱ�����½��йҵ���
        account@char               % ����ͨ��
        quote@char                 % ����ͨ��
        mark@char                  % Ͷ����־
        underlying@BaseContract    % ���ٱ��
    end
    
    methods
        
        function obj = BasePairContract()
            obj.insertTime      = datestr(now,31);
            obj.pairStrategy    = 'PAIR_MKT';
            obj.side            = '';
            obj.quantity        = 0 ;
            obj.priceMultiplier = 1;    % ����
            obj.priceShift      = 0;    % ����ʱ��ƫ��
            obj.minSize         = 1;    % ��С�ҵ���
            obj.minTick         = 0.01; % ��С�۸�
            obj.reorderSize     = 0.01; 
            obj.account         = '';
            obj.quote           = '';
            obj.mark            = '';
        end
        
        %�����Լ죬����������Ƿ���д���
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