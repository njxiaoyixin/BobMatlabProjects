classdef DataProcess < handle
    properties
        Product
        Exchange
        ProductType
        TickerSet;   %代码列表
        TickerSet_Backup %候选代码列表
        ContractMonth %合约所在月份, 格式为例如1603，类型为numeric
        LastAllowedTradeDay  %最后允许交易日（通常为交割日前一日）
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
            %PropertyNames需要是一列Cell，每个Cell里面有一个Property的名字（当只有一个Property的时候可以使用向量）
            %PropertyValues 需要是一列Cell，每个Cell对应的Property的值(当只有一个Property的时候可以使用向量)
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
            % 将Px1换合约的时间与Px2进行统一
            Px1.Time = floor(Px1.Time);
            Px2.Time = floor(Px2.Time);
            TempMainPos=nan(size(Px1.Time));
            for i=1:numel(Px1.Time)
                % 找到Px2在Px1的某个时点上对应的合约月份位置
                Ind=find(Px2.Time<=Px1.Time(i),1,'last');
                if ~isempty(Ind)
                    TempMainPos(i)=Px2.MainPos(Ind,1);
                end
            end
            Temp=TempMainPos(~isnan(TempMainPos));
            TempMainPos(isnan(TempMainPos))=Temp(1);
            % 找出Px2中的月份
            ss=arrayfun(@(x) Px2.ContractMonth(x),TempMainPos);
            % 将HG的合约对应回CU的同月份合约
            % HG数据有可能成为稀疏的（在Daily的处理上出了问题）
            Px1.MainPos = arrayfun(@(x) find(Px1.ContractMonth==x,1),ss);
            Px1.MainMonth(:,1)   = Px1.ContractMonth(Px1.MainPos)';
        end
    end
end