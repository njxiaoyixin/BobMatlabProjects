classdef BloombergData < BaseData & BaseDataMethod
    methods
        function obj=BloombergData
            %设置Constructor，赋默认值
            obj.TimeZone       = 'CN';
            obj.TargetTimeZone = 'CN';
            obj.Country        = 'US';
            obj.DataSource     = 'F:/Bloomberg高频数据';
            obj.TargetFolder   = pwd;
            obj.EDate          = today();
            obj.SDate          = datenum('2015-1-1');
            obj.ProductType    = 'FUT';
            obj.Exchange       = 'CM';
            obj.Product        = 'HG';
            obj.F_GenerateTicker(obj.Product,obj.Exchange,obj.ProductType,obj.SDate,obj.EDate,obj.Country);
            %Add a listener when TickerSet is changed, change FilenameSet
            %automatically
            %             addlistener(obj,'ChangeTickerSet',@obj.ChangeFileNameSet);
            %             notify(obj,'ChangeTickerSet')
        end
    end
    
    methods
        %与General的定义有一点点不同
    end
end