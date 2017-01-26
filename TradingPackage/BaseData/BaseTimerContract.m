classdef BaseTimerContract
    properties(SetAccess = private)
        createTime
    end
    
    properties
        contract@BaseContract  % ��Լ��Ϣ
        orderStrategy='BOL';   % ���۲���,BOL,BOP,BOC,FOK,FOA
        orderType              % Buy,Short,Sell,Cover
        quantity               % ����
        priceMultiplier =1;    % �۸�ϵ��
        priceShift   = 0;      % ���۲���������������Է��̿�ƫ�ƣ�
        minSize                % ��С����
        minTick                % ��С�۸�
        account                % ����ͨ��
        quote                  % ����ͨ��
        mark         ='Spec';  % Ͷ����־
        underlying   =' '      % ���ٱ��
        busyMode     = 'queue';% �����Ŷ�ģʽ:queue,drop
    end
    
    methods
        function obj = BaseTimerContract()
            obj.createTime = datestr(now,31);
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