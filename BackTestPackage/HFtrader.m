classdef HFtrader < trader
    %������Ƶ���ײ��Ե�trader,��ȡflow��ʽ
    %����������һ��flow����ʽ���룬��������ж��źţ��߽��н��ף�����¼��ͳ�ƽ���
    %�����׺�ͳ�Ʋ��ֿ�����ʡ�㷨���Ӷȣ�
    properties
        DailySR         % �����ձ���
        DailyMDD        % �����س�
    end
    
    methods
        function DailyClear(obj,Date,SettlePrice)
            % �������ۣ��ܽᵱ�ս��׽��
            % ���ս��׽���������������ʡ������ձ��ʡ��������س�
            
            %��ClearBook�н��յĽ��׽���ɸѡ
            Ind = find(obj.ClearBook.Time)
            
            
            if nargin <3
                ThisUnrealized = obj.CurrentStatus.Position*(SettlePrice-obj.CurrentStatus.OpenPrice);
            else
                ThisUnrealized = obj.CurrentStatus.UnrealizedRet;
            end
            
        end
        
        function PlotResult(obj)
           %��������ͼ�����ʽ�����ͼ������������ͼ�������س�ͼ
        end
    end
    
    methods(Static = true)
        function DailySRCalc(ClearBook,Date)
            % �����㷨
        end
    end
end