classdef BaseBasketContract
    properties
        contract@BaseContract;  %�����׵ĺ�Լ��Ϣ
        orderStrategy ='BOL';   % ���ӳ��۲���,BOL,BOP,BOC,FOK,FOA
        orderType               % Buy,Short,Sell,Cover
        quantity                % ����
        priceShift   = 0;       % ���۲���������������Է��̿�ƫ�ƣ�
        minSize                 % ��С����
        minTick                 % ��С�۸�
        account                 % ����ͨ��,CTP,IBTWS...
        quote                   % ����ͨ��,CTP,IBTWS...
        mark         ='Spec';   % Ͷ����־
        underlying   =' ';      % ���ٱ��
        pollTime     = 5;       % ��ѯʱ��(��)
        pollNum      = 10;      % ��ѯ����
        busyMode     = 'queue'; % �ظ��µ�����,queue,drop
        cancelAtEnd  = true;    % ��ѯ�������Ƿ񳷵�
    end
    
    methods
        %�����Լ죬����������Ƿ���д���
        function isOK=SelfCheck(obj)
            isOK=1;
            s=?BasePairContract;
            for i=1:numel(s.PropertyList)
                if isempty(obj.(s.PropertyList(i).Name))
                    isOK = 0;
                    disp(['PairContract Property ',s.PropertyList(i).Name,' is not Set!'])
                end
            end
        end
    end
end