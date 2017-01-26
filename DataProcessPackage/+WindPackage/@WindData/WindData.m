classdef WindData < BaseData & BaseDataMethod
    methods
        function obj=WindData
            %设置Constructor，赋默认值
                obj.Country      = 'CN';
                obj.DataSource    = 'F:/期货分笔数据mat';
                obj.TargetFolder  = pwd;
                obj.EDate         = today();    
                obj.SDate         = datenum('2015-1-1');
                obj.ProductType   = 'FUT';
                obj.Exchange      = 'SQ';
                obj.Product       = 'CU';
                obj.UpdateTickerSet;
            %Add a listener when TickerSet is changed, change FilenameSet
            %automatically
            %             addlistener(obj,'ChangeTickerSet',@obj.ChangeFileNameSet);
            %             notify(obj,'ChangeTickerSet')
        end
        [InternalFields,WindFields] = GenerateFields(obj)
    end
end