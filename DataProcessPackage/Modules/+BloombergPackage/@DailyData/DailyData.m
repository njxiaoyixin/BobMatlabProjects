classdef DailyData < BaseDailyData & BloombergPackage.BloombergData
    methods
        function obj=DailyData()
            obj.DataSource     = 'F:/Bloomberg·ÖÖÓÊý¾Ý';
            obj.OpenTime       = mod(datenum('5:00:00'),1);
            obj.SettleTime     = mod(datenum('6:00:00'),1);
        end
    end
end