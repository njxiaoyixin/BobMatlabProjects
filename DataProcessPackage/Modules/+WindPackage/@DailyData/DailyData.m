classdef DailyData < BaseDailyData & WindPackage.WindData
    methods
        function obj=DailyData()
            obj.DataSource='F:\期货分笔数据mat';
            obj.SettleTime = mod(datenum('15:00:00'),1);
            obj.OpenTime   = mod(datenum('15:00:01'),1);
        end
    end
end