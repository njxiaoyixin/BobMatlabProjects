classdef DataProcess < handle
    properties
        Product
        Exchange
        ProductType
        TickerSet;   %�����б�
        TickerSet_Backup %��ѡ�����б�
        ContractMonth %��Լ�����·�, ��ʽΪ����1603������Ϊnumeric
        LastAllowedTradeDay  %����������գ�ͨ��Ϊ������ǰһ�գ�
        SDate
        EDate
        TargetFolder
        PxDataSource
        HFDataSource
        DataProvider
    end
    
    methods
        function obj = DataProcess()
            obj.DataProvider = 'Wind';
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
        function Filter = HFFilter(obj,Time)
            Filter = ones(size(Time))>0;
        end
        [ Px , PxActive]  = ConstructDailyPx(obj,InputFileType,AverageDay,RollMode,DailyDataSource)
        HF  = ConstructMainHF(obj,InputFileType,Px,HF,BarDataSource)
    end
    methods(Static = true)
        function Px1 = CalibrateMainPos(Px1,Px2)
            % ��Px1����Լ��ʱ����Px2����ͳһ
            Px1.Time = floor(Px1.Time);
            Px2.Time = floor(Px2.Time);
            TempMainPos=nan(size(Px1.Time));
            for i=1:numel(Px1.Time)
                % �ҵ�Px2��Px1��ĳ��ʱ���϶�Ӧ�ĺ�Լ�·�λ��
                Ind=find(Px2.Time<=Px1.Time(i),1,'last');
                if ~isempty(Ind)
                    TempMainPos(i)=Px2.MainPos(Ind,1);
                end
            end
            Temp=TempMainPos(~isnan(TempMainPos));
            TempMainPos(isnan(TempMainPos))=Temp(1);
            % �ҳ�Px2�е��·�
            ss=arrayfun(@(x) Px2.ContractMonth(x),TempMainPos);
            % ��HG�ĺ�Լ��Ӧ��CU��ͬ�·ݺ�Լ
            % HG�����п��ܳ�Ϊϡ��ģ���Daily�Ĵ����ϳ������⣩
            Px1.MainPos = arrayfun(@(x) find(Px1.ContractMonth==x,1),ss);
            Px1.MainMonth(:,1)   = Px1.ContractMonth(Px1.MainPos)';
        end
    end
end