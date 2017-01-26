classdef BaseData < handle
    properties%(Access = 'private')
        API
        Product;  %��Ʒ����-������ʾʹ��
        Product_Backup   %����ò�Ʒ������ticker
        Exchange; %��һ������
        ProductType %��Ʒ����-STK,FUT,INDEX
        TickerSet;   %�����б�
        TickerSet_Backup %��ѡ�����б�
        ContractMonth %��Լ�����·�, ��ʽΪ����1603������Ϊnumeric
        LastAllowedTradeDay  %����������գ�ͨ��Ϊ������ǰһ�գ�
        SDate;       %��ʼʱ��
        EDate;       %����ʱ��
        TargetFolder;%Ŀ��洢�ļ���
        DataSource;  %������Դ��Ŀ¼��FTP��ַ��
        Country      %���ڹ��ң�����Bloomberg��CQG��ȡ��Ʊ��
        TimeZone     %ԭʼ���ݵ�ʱ��,������ֵ��'CN','EST','CST'
        TargetTimeZone %Ŀ��ʱ��,������ֵ��'CN','EST','CST'
    end
    
    methods  %ͨ�ú���
        function obj = BaseData()
            
        end
        
        % obj1 > obj2��ʾ��obj1�Ĳ���ȫ����ֵ��obj2
        function r = gt(obj1,obj2)
            Fields = fieldnames(obj1);
            for i=1:numel(Fields)
                obj2.(Fields{i}) = obj1.(Fields{i});
            end
            r=1;
        end
        
        function SetProperties(obj, varargin )
            %PropertyNames��Ҫ��һ��Cell��ÿ��Cell������һ��Property�����֣���ֻ��һ��Property��ʱ�����ʹ��������
            %PropertyValues ��Ҫ��һ��Cell��ÿ��Cell��Ӧ��Property��ֵ(��ֻ��һ��Property��ʱ�����ʹ������)
            argin=varargin;
            if numel(argin)>0 && mod(numel(argin),2)==0
                for i=2:2:numel(argin)
                    obj.(argin{i-1})=argin{i};
                end
            end
        end
        
        function BrowseTargetFolder(obj)
            %�����������û�ѡ�������ݵ�λ��
            ThisTargetFolder=uigetdir(['/',obj.Product],'Please Choose a Target Folder for the Data!');
            obj.SetProperties('TargetFolder',ThisTargetFolder);
        end
        
        function BrowseSourceFolder(obj)
            %�����������û�ѡ�������ݵ�λ��
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