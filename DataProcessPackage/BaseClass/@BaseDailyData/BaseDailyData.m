classdef BaseDailyData < handle
    properties
        OpenTime
        SettleTime
        OpenTimeOffset    %�����-1���������ʱ����ǰһ�������գ���Ϊ-1�������
        custTime
    end
    
    methods
        function obj=BaseDailyData
            obj.custTime = 0; % Ĭ�ϲ������Զ��忪����ʱ��
        end
    end

end