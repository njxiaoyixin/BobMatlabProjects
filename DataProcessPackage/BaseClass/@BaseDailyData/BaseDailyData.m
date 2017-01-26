classdef BaseDailyData < handle
    properties
        OpenTime
        SettleTime
        OpenTimeOffset    %如果是-1，则代表开盘时间在前一个交易日，不为-1则代表本日
        custTime
    end
    
    methods
        function obj=BaseDailyData
            obj.custTime = 0; % 默认不设置自定义开收盘时间
        end
    end

end