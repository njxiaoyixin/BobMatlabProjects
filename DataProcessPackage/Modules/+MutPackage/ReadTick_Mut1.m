classdef ReadTick_Mut1 < WindPackage.ReadTick
    %��9����滻Ϊ9��02
    methods
        function Data3 = F_LoadIntradayBar(~,Data,Interval)
    %%
            % Interval��λΪ���ӣ�����Ϊ60��Լ��
            % Data�ں�9��Field��������״̬�����ۻ���������ֻʹ�����µ�����
            % ״̬����Time,Open,High,Low,Close,Last_Open_Int,Avg_Open_Int,TWAP,VWAP,Avg_Bid_Size,Avg_BidPrice,Avg_Ask_Price,Avg_Ask_Size
            % �ۻ�����Volume,value
            
            % ����Interval����һ���ʱ������
            TimeSeries = (0:(Interval/24/60):1)';
            %��9����滻Ϊ9��02
            TimeSeries(TimeSeries==9/24)=9/24+2/60/24;
            % ����Data����������ʱ��Slots
            DateSeries     = unique(floor(Data.Time));
            TimeSlots_Temp = repmat(TimeSeries,1,numel(DateSeries))+repmat(DateSeries',numel(TimeSeries),1);
            TimeSlots=[];
            for i=1:numel(DateSeries)
                TimeSlots=[TimeSlots;TimeSlots_Temp(:,i)]; %#ok<AGROW>
            end
            Data2.Time         = TimeSlots;
            Data2.Open         = nan(size(TimeSlots));
            Data2.High         = nan(size(TimeSlots));
            Data2.Low          = nan(size(TimeSlots));
            Data2.Close        = nan(size(TimeSlots));
            Data2.Volume       = nan(size(TimeSlots));
            Data2.Value        = nan(size(TimeSlots));
            Data2.NumTick      = nan(size(TimeSlots));
            Data2.Open_Int     = nan(size(TimeSlots));
            %             Data2.TWAP         = nan(size(TimeSlots));
            %             Data2.VWAP         = nan(size(TimeSlots));
            %             Data2.Avg_Bid_Size = nan(size(TimeSlots));
            %             Data2.Avg_Bid_Price= nan(size(TimeSlots));
            %             Data2.Avg_Ask_Size = nan(size(TimeSlots));
            %             Data2.Avg_Ask_Price= nan(size(TimeSlots));
            if ~isfield(Data,'Open') %���ʹ�õ���tick����
                for i=2:numel(TimeSlots)
                    if numel(TimeSlots)==1
                        SubIndex        = (Data.Time<=TimeSlots(i) & Data.Price~=0);
                    else
                        %ע����仰�ǹ�����������ݴ���ʱΨһ�Ĳ�֮ͬ������Ҫ��ȡ����Trade������
                        SubIndex        = (Data.Time<=TimeSlots(i) & Data.Time>TimeSlots(i-1) & Data.Price~=0 & Data.Volume~=0);
                    end
                    if any(SubIndex)
                        if isfield(Data,'Price')
                            Sub.Price          = Data.Price(SubIndex);
                            Data2.Open(i)      = Sub.Price(1);
                            Data2.High(i)      = max(Sub.Price);
                            Data2.Low(i)       = min(Sub.Price);
                            Data2.Close(i)     = Sub.Price(end);
                            if isfield(Data,'Volume')
                                Sub.Volume         = Data.Volume(SubIndex);
                                Data2.Value(i)     = sum(Sub.Volume.*Sub.Price);
                            end
                        end
                        if isfield(Data,'Volume')
                            Sub.Volume         = Data.Volume(SubIndex);
                            Data2.Volume(i)    = sum(Sub.Volume);
                        end
                        if isfield(Data,'Open_Int')
                            Sub.Open_Int       = Data.Open_Int(SubIndex);
                            Data2.Open_Int(i)  = Sub.Open_Int(end);
                        end
                        Data2.NumTick(i)   = sum(isnan(Sub.Price));
                    end
                end
            else%���ʹ�õ���bar����
                for i=2:numel(TimeSlots)
                    SubIndex        = (Data.Time<=TimeSlots(i) & Data.Time>TimeSlots(i-1) & Data.Close~=0 & Data.Volume~=0);
                    if any(SubIndex)
                        if isfield(Data,'Open')
                            Sub.Open           = Data.Open(SubIndex);
                            Data2.Open(i)      = Sub.Open(1);
                        end
                        if isfield(Data,'High')
                            Sub.High           = Data.High(SubIndex);
                            Data2.High(i)      = max(Sub.High);
                        end
                        if isfield(Data,'Low')
                            Sub.Low            = Data.Low(SubIndex);
                            Data2.Low(i)       = min(Sub.Low);
                        end
                        if isfield(Data,'Close')
                            Sub.Close          = Data.Close(SubIndex);
                            Data2.Close(i)     = Sub.Close(end);
                        end
                        if isfield(Data,'Volume')
                            Sub.Volume         = Data.Volume(SubIndex);
                            Data2.Volume(i)    = sum(Sub.Volume);
                        end
                        if isfield(Data,'Value')
                            Sub.Value          = Data.Value(SubIndex);
                            Data2.Value(i)     = sum(Sub.Value);
                        end
                        if isfield(Data,'NumTick')
                            Sub.NumTick        = Data.NumTick(SubIndex);
                            Data2.NumTick(i)   = sum(Sub.NumTick);
                        end
                        if isfield(Data,'Open_Int')
                            Sub.Open_Int       = Data.Open_Int(SubIndex);
                            Data2.Open_Int(i)  = Sub.Open_Int(end);
                        end
                        if isfield(Data,'OI')
                            Sub.Open_Int       = Data.OI(SubIndex);
                            Data2.Open_Int(i)  = Sub.Open_Int(end);
                        end
                    end
                end 
            end
            %��û�����ݵ�TimeSlot�ӵ�
            Fields  = fieldnames(Data2);
            Filter  = ~isnan(Data2.Close);
            for i = 1:numel(Fields)
                if ~all(isnan(Data2.(Fields{i})))&&~isempty(Filter)%ȷ���������ڣ���ȫΪnan
                    Data3.(Fields{i}) = Data2.(Fields{i})(Filter);
                end
            end
        end
    end
end