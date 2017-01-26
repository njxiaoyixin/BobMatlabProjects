classdef trader<handle
    properties(Hidden)
        InitialFund    %初始资金
        TradeCost      %交易成本
    end
    
    properties
        Product         %交易的产品名称
        Multiplier      %乘数
        TimeSeries      %包含时间、价格、成交量等参数的object
        TimeVec         %回测的时间序列
        AssetVec        %资产曲线
        PositionVec     %仓位向量
        RetVec          %收益率向量
        DateVec         %日期向量
        DailyRetVec     %日收益率向量
        DailyGainVec    %日收益额向量
        DailyAssetVec   %日市值向量
        FundChangeVec   %资金进出
        DailyFundChangeVec %日资金进出
        TBook@TradeBook;%成交记录
        CBook@ClearBook %平仓记录
        CurrentStatus   %现在状态
        Output;         %交易结果输出
        IsFx            %是否是外币标价
        Fx              %汇率序列
        DailyFx         %日汇率序列
    end
    
    properties(Access=private)
        Ind
    end
    
    events
        UpdateStatus
    end
    
    methods %Initialize and Basic functions
        function obj=trader(TheTradeCost,TheInitialFund,num_ent,num_day)
            %Constructor: Initialize the trader class
            %The Default values for the for parameters are:
            %TheTradeCost    =  0
            %TheInitialFund  =  1000000
            %num_ent         =  0
            %num_day         =  0
            if nargin<=3
                num_day=0;
            end
            if nargin<=2
                num_ent=0;
            end
            if nargin<=1
                TheInitialFund=1000000;
            end
            if nargin==0
                TheTradeCost=0.00025;
            end
            
            obj.Multiplier    = 1;
            obj.TradeCost=TheTradeCost;
            obj.InitialFund   = TheInitialFund;
            obj.TimeVec       = zeros(num_ent,1);
            obj.AssetVec      = ones(num_ent,1)*obj.InitialFund;
            obj.RetVec        = zeros(num_ent,1);
            obj.DateVec       = zeros(num_day,1);
            obj.PositionVec   = zeros(num_ent,1);
            obj.DailyRetVec   = zeros(num_day,1);
            obj.DailyGainVec  = zeros(num_day,1);
            obj.DailyAssetVec = zeros(num_day,1);
            obj.FundChangeVec = zeros(num_ent,1);
            obj.DailyFundChangeVec = zeros(num_day,1);
            obj.TBook=TradeBook;
            obj.CBook=ClearBook;
            obj.CurrentStatus=Status(TheInitialFund);
            obj.CurrentStatus.Multiplier = obj.Multiplier;
            obj.Output=OutputStruct;
            obj.IsFx=0;
            obj.Fx=1;
            obj.DailyFx = obj.Fx;
            
            addlistener(obj,'UpdateStatus',@obj.UpdateStatus);
        end
        %Constructor
        
        function PreSetTimeSeries(obj,ThisTimeSeries)
            obj.SetProperties('TimeSeries',ThisTimeSeries);
            obj.SetProperties('TimeVec',obj.TimeSeries.TimeVec);
            num_ent = numel(obj.TimeVec);
            num_day = numel(unique(floor(obj.TimeVec)));
            
            obj.AssetVec=ones(num_ent,1)*obj.InitialFund;
            obj.RetVec=zeros(num_ent,1);
            obj.Fx    = ones(num_ent,1);
            %             obj.DateVec=unique(floor(obj.TimeVec));
            obj.PositionVec=zeros(num_ent,1);
            obj.FundChangeVec = zeros(num_ent,1);
            %             obj.DailyRetVec=zeros(num_day,1);
            %             obj.DailyGainVec=zeros(num_day,1);
        end
        %注：开始测试之前可以先将时间序列变量输入(只用于回测)
        
        function SetFx(obj,Fx)
            obj.IsFx=1;
            obj.Fx=Fx;
            obj.DailyFx = obj.Fx(1);
        end
        %设置外汇数据
        
        function SetProperties(obj, varargin )
            %PropertyNames需要是一列Cell，每个Cell里面有一个Property的名字（当只有一个Property的时候可以使用向量）
            %PropertyValues 需要是一列Cell，每个Cell对应的Property的值(当只有一个Property的时候可以使用向量)
            argin=varargin;
            if numel(argin)>0 && mod(numel(argin),2)==0
                for i=2:2:numel(argin)
                    obj.(argin{i-1})=argin{i};
                end
                if strcmpi(argin{i-1},'Multiplier')
                    obj.CurrentStatus.(argin{i-1})=argin{i};
                end
            end
        end
        %设置属性
        
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
        %获取属性
        
        function AddFund(obj,ThisFund,i)
            if nargin <2
                i=numel(obj.FundChangVec)+1;
            end
            obj.FundChangeVec(i) =ThisFund;
            obj.CurrentStatus.ChangeFund(ThisFund)
        end
        %增加资金
        
        function ExtractFund(obj,ThisFund,i)
            if ThisFund >obj.CurrentStatus.Fund
                disp('Insufficient Fund! Only Extract Remaining!')
                ThisFund=obj.CurrentStatus.Fund;
            end
            if nargin <2
                i=numel(obj.FundChangVec)+1;
            end
            obj.FundChangeVec(i) =ThisFund;
            obj.CurrentStatus.ChangeFund(-ThisFund);
        end
        %减少资金
        
        function p=GetPosition(obj)
            p=obj.CurrentStatus.GetPosition();
        end
        %获取当前仓位
    end
    
    methods %Trade Functions
        update(obj,time,price,i)             %更新当前状态
        buy(obj,time,price,quantity,i)       %        买入
        sell(obj,time,price,quantity,i)      %卖出
        closeshort(obj,time,price,quantity,i)%平空头
        closelong(obj,time,price,quantity,i) %平多头
        coverall(obj,time,price,~,i)         %平掉所有头寸
        function AddStopLoss(obj)
            obj.Output.StopLossNum=obj.Output.StopLossNum+1;
        end         %记录增加一次止损
        function AddProfitTake(obj)
            obj.Output.ProfitTakeNum=obj.Output.ProfitTakeNum+1;
        end       %记录增加一次止盈
    end
    
    methods %盘后统计
        DailyCalc(obj) %计算日收益率序列
        DailyClearance(obj,Date,Settle)        %用于在高频回测时，以天为单位输入，当天回测完毕后输入结算价，结算日收益率序列
        OutputCalc(obj)    %计算输出
        CombTrader=plus(obj1,obj2) %重载加法，初始资金取更大者（相当于放杠杆）
        function CombTrader=or(obj1,obj2)
            %Note：The two traders must be under the same currency
            CombTrader = trader(obj1.TradeCost+obj2.TradeCost,obj1.InitialFund+obj2.InitialFund);
            ThisTimeSeries.TimeVec=union(obj1.TimeVec,obj2.TimeVec);
            CombTrader.PreSetTimeSeries(ThisTimeSeries)
            % 合并DateVec 和 DailyGainVec, DailyAssetVec, DailyFundChangeVec
            CombTrader.DateVec            = union(obj1.DateVec,obj2.DateVec);
            CombTrader.DailyAssetVec      = zeros(numel(CombTrader.DateVec),1);
            CombTrader.DailyGainVec       = zeros(numel(CombTrader.DateVec),1);
            CombTrader.DailyFundChangeVec = zeros(numel(CombTrader.DateVec),1);
            for i=1:numel(CombTrader.DateVec)
                ThisFx1 = obj1.DailyFx(obj1.DateVec==CombTrader.DateVec(i));
                ThisFx2 = obj2.DailyFx(obj2.DateVec==CombTrader.DateVec(i));
                ThisDailyAsset1      = ThisFx1*obj1.DailyAssetVec(obj1.DateVec==CombTrader.DateVec(i));
                ThisDailyAsset2      = ThisFx2*obj2.DailyAssetVec(obj2.DateVec==CombTrader.DateVec(i));
                ThisDailyGain1   = ThisFx1*obj1.DailyGainVec(obj1.DateVec==CombTrader.DateVec(i));
                ThisDailyGain2   = ThisFx2*obj2.DailyGainVec(obj2.DateVec==CombTrader.DateVec(i));
                ThisDailyFundChange1  = ThisFx1*obj1.DailyFundChangeVec(obj1.DateVec==CombTrader.DateVec(i));
                ThisDailyFundChange2  = ThisFx2*obj2.DailyFundChangeVec(obj2.DateVec==CombTrader.DateVec(i));
                CombTrader.DailyAssetVec(i)=CombTrader.DailyGainVec(i)+EmptyorZero(ThisDailyAsset1)+EmptyorZero(ThisDailyAsset2);
                CombTrader.DailyGainVec(i)=CombTrader.DailyGainVec(i)+...
                    EmptyorZero(ThisDailyGain1)+EmptyorZero(ThisDailyGain2);
                CombTrader.DailyFundChangeVec(i)=CombTrader.DailyFundChangeVec(i)+...
                    EmptyorZero(ThisDailyFundChange1)+EmptyorZero(ThisDailyFundChange2);
            end
            %计算CombTrader.DailyRetVec防止前一天的市值为0，出现相除出现nan的情况
            DailyAssetVec_Lag1=[CombTrader.InitialFund;CombTrader.DailyAssetVec(1:end-1)];
            CombTrader.DailyRetVec = zeros(size(CombTrader.DateVec));
            for i=1:numel(CombTrader.DailyAssetVec)
                if DailyAssetVec_Lag1(i)~=0
                    CombTrader.DailyRetVec(i) = (CombTrader.DailyAssetVec(i)-CombTrader.DailyFundChangeVec(i)-...
                        DailyAssetVec_Lag1(i))/DailyAssetVec_Lag1(i);
                end
            end
            
            %CBook
            CombTrader.CBook.TimeVec=[obj1.CBook.TimeVec;obj2.CBook.TimeVec];
            CombTrader.CBook.GainVec=[obj1.CBook.GainVec;obj2.CBook.GainVec];
            CombTrader.CBook.RetVec=[obj1.CBook.RetVec;obj2.CBook.RetVec];
            CombTrader.CBook.CostVec=[obj1.CBook.CostVec;obj2.CBook.CostVec];
            CombTrader.CBook.PositionVec=[obj1.CBook.PositionVec;obj2.CBook.PositionVec];
            CombTrader.CBook.TransFeeVec=[obj1.CBook.TransFeeVec;obj2.CBook.TransFeeVec];
            CombTrader.CBook.GainVec=zeros(length(CombTrader.CBook.TimeVec),1);
            % To be continued....PositionVec, AssetVec, TBook....
        end
        %重载或，将两个trader object的收益合并，未完成
        DispResult(obj)        %展示Output
        PlotResult(obj)        %画出交易结果图
    end
    
    methods(Static = true) %附加函数
        function Bool = isNightSession(time)
            CloseTime=2.5/24.0;%Night Session closes at 2:30
            OpenTime=21.0/24.0;%Day Session Opens at 21:00
            if mod(time)>OpenTime||mod(time)<CloseTime
                Bool=1;
            else
                Bool=0;
            end
        end
        %是否是夜盘
        function Bool=isAnotherDay(time1,time2)
            CloseTime=15.0/24.0;%Day Session closes at 15:00
            OpenTime=9.0/24.0;%Day Session Opens at 9:00
            % If time1 is within the day session
            if mod(time1,1)==0 && mod(time2,1)==0 && time1~=time2
                %说明是日数据
                Bool=1;
                return
            end
            
            if mod(time1,1)<=CloseTime&&mod(time1,1)>=OpenTime&&...
                    (floor(time1)+CloseTime)<time2
                Bool=1;
            else
                Bool=0;
            end
        end
        %判断是否是下一天
        function Annualized=Annualize(x,n,format)
            %A year has approximately 252 trading days
            if nargin<3
                format=1;
            end
            if format~=1
                Annualized=x*sqrt(252/n);
            else
                Annualized=x*252/n;
            end
        end
        %年化的标准       
    end
end

