classdef BaseRiskEngine
    %��Ҫ��صķ��ָ��
    % 1. ��֤���ܳ�������
    % 2. ���в�λ���ܳ��������������߹���
    % 3. ����Լ�����������ܳ�������
    % 4. ��Ʊ�ĳֱֲ������ܳ�������
    % 5. �����������ܳ�������
    % 6. ����ʵ�ֿ����ܳ�������
    % 7. �ֲֿ����ܳ�������
    
    properties%���ָ��
        MaxMargin                    % ���֤��
        MaxPosition @ BasePosition   % ����λ
        MaxContractCancel            % ��󳷵�
        MaxShare                     % ���ɷݱ���
        MaxOpenPosition              % ��󿪲�����
        MaxRealizedLoss              % ���ʵ�ֿ���
        MaxUnrealizedLoss            % ��󸡶�����
    end
    properties(SetAccess = private)
        Listener
    end
    methods%������ָ�겢������ʾ
        function StartRiskEngine(obj)
            
        end
        function StopRiskEngine(obj)
            
        end
        CalcContractCancel(obj)
    end
end