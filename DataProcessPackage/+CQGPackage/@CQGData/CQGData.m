classdef CQGData < BaseData & BaseDataMethod
    methods
        function obj=CQGData
                obj.Country       = 'US';
                obj.DataSource    = 'H:\CQGÊý¾Ý';
                obj.TargetFolder  = pwd;
                obj.EDate         = today();
                obj.SDate         = datenum('2015-1-1');
                obj.ProductType   = 'FUT';
                obj.Exchange      = 'CM';
                obj.Product       = 'CPE';
                obj.F_GenerateTicker(obj.Product,obj.Exchange,obj.ProductType,obj.SDate,obj.EDate,obj.Country);

            %Add a listener when TickerSet is changed, change FilenameSet
            %automatically
            %             addlistener(obj,'ChangeTickerSet',@obj.ChangeFileNameSet);
            %             notify(obj,'ChangeTickerSet')
        end
    end
end