
function DataOut = F_FreqTrans(obj,Data,isIntraday,OpenTimeSlots,TimeSlots)
Fields         = fieldnames(Data);
Data2.Time     = TimeSlots;
if ~isfield(Data,'Close') && isfield(Data,'Price') %���ʹ�õ���tick����
    OutFields = {'Open','High','Low','Close','Volume','Amount','OpenInt','NumTick'};
    for iField=1:numel(OutFields)
        Data2.(OutFields{iField}) = nan(size(TimeSlots));
    end
    % �����ѡField��
    %             Data2.OpenInt     = nan(size(TimeSlots));
    %             Data2.TWAP         = nan(size(TimeSlots));
    %             Data2.VWAP         = nan(size(TimeSlots));
    %             Data2.Avg_Bid_Size = nan(size(TimeSlots));
    %             Data2.Avg_Bid_Price= nan(size(TimeSlots));
    %             Data2.Avg_Ask_Size = nan(size(TimeSlots));
    %             Data2.Avg_Ask_Price= nan(size(TimeSlots));
    Selected.Ind = obj.F_TickFilter(Data);
    %����ԭʼ���ݣ�Ȼ��������Timeslot���
    Selected.Time   = Data.Time(Selected.Ind);
    Selected.Price  = Data.Price(Selected.Ind);
    Selected.Volume = Data.Volume(Selected.Ind);
    Sub.Price  = [];
    Sub.Volume = [];
    if isfield(Data,'OpenInt')
        Sub.OpenInt=[];
        Selected.OpenInt = Data.OpenInt(Selected.Ind);
    end
    for iDate=1:numel(Selected.Time)
        Sub.Price  = [Sub.Price;Selected.Price(iDate)];
        Sub.Volume = [Sub.Volume;Selected.Volume(iDate)];
        if isfield(Data,'OpenInt')
            Sub.OpenInt=[Sub.OpenInt;Selected.OpenInt(iDate)];
        end
        if iDate==numel(Selected.Time) %��������һ�����ݣ���Ϊ�ͺ���һ�����ݲ�ͬ
            j =  find(Selected.Time(iDate)<=TimeSlots,1,'first');
            if any(j)
                if isfield(Data,'Price')
                    Data2.Open(j)      = Sub.Price(1);
                    Data2.High(j)      = max(Sub.Price);
                    Data2.Low(j)       = min(Sub.Price);
                    Data2.Close(j)     = Sub.Price(end);
                    if isfield(Data,'Volume')
                        Data2.Amount(j) = sum(double(Sub.Volume).*Sub.Price);
                    end
                end
                if isfield(Data,'Volume')
                    Data2.Volume(j)    = sum(Sub.Volume);
                end
                if isfield(Data,'OpenInt')
                    Data2.OpenInt(j)  = Sub.OpenInt(end);
                end
                Data2.NumTick(j)   = sum(~isnan(Sub.Price));
            end
            break
        end
        
        %�����ǰ���ݺͺ�һ������������Interval��ͬ�����¼�ö�����
        if isIntraday
            BookTrigger = floor(Selected.Time(iDate)/(1/24/60/Interval))~=floor(Selected.Time(iDate+1)/(1/24/60/Interval));  %��ʵ���Ժ�else��ϲ������������㷨���ٲ��Ҵ���������Ч��
        else
            BookTrigger = find(Selected.Time(iDate)<=TimeSlots,1,'first') ~= find(Selected.Time(iDate+1)<=TimeSlots,1,'first');
        end
        if BookTrigger  %����ͺ�һ���ӵ�interval��ͬ
            j =  find(Selected.Time(iDate)<=TimeSlots,1,'first');
            if any(j)
                if isfield(Data,'Price')
                    Data2.Open(j)      = Sub.Price(1);
                    Data2.High(j)      = max(Sub.Price);
                    Data2.Low(j)       = min(Sub.Price);
                    Data2.Close(j)     = Sub.Price(end);
                    if isfield(Data,'Volume')
                        Data2.Amount(j)     = sum(double(Sub.Volume).*Sub.Price);
                    end
                end
                if isfield(Data,'Volume')
                    Data2.Volume(j)    = sum(Sub.Volume);
                end
                if isfield(Data,'OpenInt')
                    Data2.OpenInt(j)  = Sub.OpenInt(end);
                end
                Data2.NumTick(j)   = sum(~isnan(Sub.Price));
            end
            Sub.Price  = [];
            Sub.Volume = [];
            if isfield(Data,'OpenInt')
                Sub.OpenInt=[];
            end
        else %�����ǰһ���ӵ�interval��ͬ
        end
    end
else%���ʹ�õ���bar����Daily����
    for iField = 1:numel(Fields)
        if ~strcmpi(Fields{iField},'Time')
            Data2.(Fields{iField}) = nan(size(TimeSlots));
        end
    end
%     �����1�������ݣ����ô���
%     if Interval == 1 && isIntraday 
%         DataOut = Data;
%         return
%     end
    for iDate=1:numel(TimeSlots)
        SubIndex   = (Data.Time<=TimeSlots(iDate) & Data.Time>=OpenTimeSlots(iDate) & Data.Close~=0);
        for iField = 1:numel(Fields)
            if strcmpi(Fields{iField},'Time')
                continue
            end
            if any(SubIndex)
                Sub.(Fields{iField})      = Data.(Fields{iField})(SubIndex);
                switch upper(Fields{iField})
                    case 'OPEN'
                        Data2.(Fields{iField})(iDate) = Sub.(Fields{iField})(1);
                    case 'HIGH'
                        Data2.(Fields{iField})(iDate) = nanmax(Sub.(Fields{iField}));
                    case 'LOW'
                        Data2.(Fields{iField})(iDate) = nanmin(Sub.(Fields{iField}));
                    case {'VOLUME','VALUE','AMOUNT','NUMTICK'}
                        Data2.(Fields{iField})(iDate) = nansum(Sub.(Fields{iField}));
                    otherwise
                        Data2.(Fields{iField})(iDate) = Sub.(Fields{iField})(end);
                end
            end
        end
    end
end
% ���ڹ��ڵ�15��������15:15�������ݿ��ܻ���ʾȫ��ĳɽ������ʽ��õ�ȥ��
Fields  = fieldnames(Data2);
timeFilter = ~abs(mod(Data2.Time,1)-15/24) < 1/60/24 | abs(mod(Data2.Time,1)-(15/24+15/60/24)) < 1/60/24;
%��û�����ݵ�TimeSlot�ӵ�
dataFilter  = ~isnan(Data2.Close);
% ��ʼ����
DataOut = [];
for iDate = 1:numel(Fields)
    if ~all(isnan(Data2.(Fields{iDate})))&& ~isempty(timeFilter) &&~isempty(dataFilter) %ȷ���������ڣ���ȫΪnan
        DataOut.(Fields{iDate}) = Data2.(Fields{iDate})(dataFilter & timeFilter);
    end
end
end