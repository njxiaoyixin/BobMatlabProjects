classdef trader<handle
    properties(Hidden)
        InitialFund    %��ʼ�ʽ�
        TradeCost      %���׳ɱ�
    end
    
    properties
        Product         %���׵Ĳ�Ʒ����
        Multiplier      %����
        TimeSeries      %����ʱ�䡢�۸񡢳ɽ����Ȳ�����object
        TimeVec         %�ز��ʱ������
        AssetVec        %�ʲ�����
        PositionVec     %��λ����
        RetVec          %����������
        DateVec         %��������
        DailyRetVec     %������������
        DailyGainVec    %�����������
        DailyAssetVec   %����ֵ����
        FundChangeVec   %�ʽ����
        DailyFundChangeVec %���ʽ����
        TBook@TradeBook;%�ɽ���¼
        CBook@ClearBook %ƽ�ּ�¼
        CurrentStatus   %����״̬
        Output;         %���׽�����
        IsFx            %�Ƿ�����ұ��
        Fx              %��������
        DailyFx         %�ջ�������
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
        %ע����ʼ����֮ǰ�����Ƚ�ʱ�����б�������(ֻ���ڻز�)
        
        function SetFx(obj,Fx)
            obj.IsFx=1;
            obj.Fx=Fx;
            obj.DailyFx = obj.Fx(1);
        end
        %�����������
        
        function SetProperties(obj, varargin )
            %PropertyNames��Ҫ��һ��Cell��ÿ��Cell������һ��Property�����֣���ֻ��һ��Property��ʱ�����ʹ��������
            %PropertyValues ��Ҫ��һ��Cell��ÿ��Cell��Ӧ��Property��ֵ(��ֻ��һ��Property��ʱ�����ʹ������)
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
        %��������
        
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
        %��ȡ����
        
        function AddFund(obj,ThisFund,i)
            if nargin <2
                i=numel(obj.FundChangVec)+1;
            end
            obj.FundChangeVec(i) =ThisFund;
            obj.CurrentStatus.ChangeFund(ThisFund)
        end
        %�����ʽ�
        
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
        %�����ʽ�
        
        function p=GetPosition(obj)
            p=obj.CurrentStatus.GetPosition();
        end
        %��ȡ��ǰ��λ
    end
    
    methods %Trade Functions
        update(obj,time,price,i)             %���µ�ǰ״̬
        buy(obj,time,price,quantity,i)       %        ����
        sell(obj,time,price,quantity,i)      %����
        closeshort(obj,time,price,quantity,i)%ƽ��ͷ
        closelong(obj,time,price,quantity,i) %ƽ��ͷ
        coverall(obj,time,price,~,i)         %ƽ������ͷ��
        function AddStopLoss(obj)
            obj.Output.StopLossNum=obj.Output.StopLossNum+1;
        end         %��¼����һ��ֹ��
        function AddProfitTake(obj)
            obj.Output.ProfitTakeNum=obj.Output.ProfitTakeNum+1;
        end       %��¼����һ��ֹӯ
    end
    
    methods %�̺�ͳ��
        DailyCalc(obj) %����������������
        DailyClearance(obj,Date,Settle)        %�����ڸ�Ƶ�ز�ʱ������Ϊ��λ���룬����ز���Ϻ��������ۣ�����������������
        OutputCalc(obj)    %�������
        CombTrader=plus(obj1,obj2) %���ؼӷ�����ʼ�ʽ�ȡ�����ߣ��൱�ڷŸܸˣ�
        function CombTrader=or(obj1,obj2)
            %Note��The two traders must be under the same currency
            CombTrader = trader(obj1.TradeCost+obj2.TradeCost,obj1.InitialFund+obj2.InitialFund);
            ThisTimeSeries.TimeVec=union(obj1.TimeVec,obj2.TimeVec);
            CombTrader.PreSetTimeSeries(ThisTimeSeries)
            % �ϲ�DateVec �� DailyGainVec, DailyAssetVec, DailyFundChangeVec
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
            %����CombTrader.DailyRetVec��ֹǰһ�����ֵΪ0�������������nan�����
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
        %���ػ򣬽�����trader object������ϲ���δ���
        DispResult(obj)        %չʾOutput
        PlotResult(obj)        %�������׽��ͼ
    end
    
    methods(Static = true) %���Ӻ���
        function Bool = isNightSession(time)
            CloseTime=2.5/24.0;%Night Session closes at 2:30
            OpenTime=21.0/24.0;%Day Session Opens at 21:00
            if mod(time)>OpenTime||mod(time)<CloseTime
                Bool=1;
            else
                Bool=0;
            end
        end
        %�Ƿ���ҹ��
        function Bool=isAnotherDay(time1,time2)
            CloseTime=15.0/24.0;%Day Session closes at 15:00
            OpenTime=9.0/24.0;%Day Session Opens at 9:00
            % If time1 is within the day session
            if mod(time1,1)==0 && mod(time2,1)==0 && time1~=time2
                %˵����������
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
        %�ж��Ƿ�����һ��
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
        %�껯�ı�׼       
    end
end

