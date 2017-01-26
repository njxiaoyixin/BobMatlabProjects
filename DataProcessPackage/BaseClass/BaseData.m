classdef BaseData < handle
    properties%(Access = 'private')
        API
        Product;  %产品名称-仅作标示使用
        Product_Backup   %如果该产品更换过ticker
        Exchange; %单一交易所
        ProductType %产品类型-STK,FUT,INDEX
        TickerSet;   %代码列表
        TickerSet_Backup %候选代码列表
        ContractMonth %合约所在月份, 格式为例如1603，类型为numeric
        LastAllowedTradeDay  %最后允许交易日（通常为交割日前一日）
        SDate;       %开始时间
        EDate;       %结束时间
        TargetFolder;%目标存储文件夹
        DataSource;  %数据来源根目录（FTP地址）
        Country      %所在国家（用于Bloomberg和CQG提取股票）
        TimeZone     %原始数据的时区,可输入值：'CN','EST','CST'
        TargetTimeZone %目标时区,可输入值：'CN','EST','CST'
    end
    
    methods  %通用函数
        function obj = BaseData()
            
        end
        
        % obj1 > obj2表示将obj1的参数全部赋值给obj2
        function r = gt(obj1,obj2)
            Fields = fieldnames(obj1);
            for i=1:numel(Fields)
                obj2.(Fields{i}) = obj1.(Fields{i});
            end
            r=1;
        end
        
        function SetProperties(obj, varargin )
            %PropertyNames需要是一列Cell，每个Cell里面有一个Property的名字（当只有一个Property的时候可以使用向量）
            %PropertyValues 需要是一列Cell，每个Cell对应的Property的值(当只有一个Property的时候可以使用向量)
            argin=varargin;
            if numel(argin)>0 && mod(numel(argin),2)==0
                for i=2:2:numel(argin)
                    obj.(argin{i-1})=argin{i};
                end
            end
        end
        
        function BrowseTargetFolder(obj)
            %弹出窗口让用户选择存放数据的位置
            ThisTargetFolder=uigetdir(['/',obj.Product],'Please Choose a Target Folder for the Data!');
            obj.SetProperties('TargetFolder',ThisTargetFolder);
        end
        
        function BrowseSourceFolder(obj)
            %弹出窗口让用户选择存放数据的位置
            ThisSourceFolder=uigetdir(['/',obj.Product],'Please Choose a Source Folder for the Data!');
            obj.SetProperties('DataSource',ThisSourseFolder);
        end
        
        function Output=GetProperties(obj,varargin)
            argin=varargin;
            Output=cell(numel(argin));
            if numel(argin)>1
                for i=1:(numel(argin))
                    Output{i}=obj.(argin{i});
                end
            elseif numel(argin)==1
                Output=obj.(argin{1});
            end
        end
    end
end