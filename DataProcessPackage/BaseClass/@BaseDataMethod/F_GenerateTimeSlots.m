function [OpenTimeSlots,TimeSlots]=F_GenerateTimeSlots(obj,TimeSeries,varargin)
% TimeSeries is vector that contains time

%����Ĭ�ϲ���
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���

% Ĭ���Ǻϳ�1�������
addParameter(p,'Interval',1,@isnumeric);
addParameter(p,'isIntraday',false,@(x)islogical(x)||isnumeric(x));
addParameter(p,'byWeek',false,@(x)islogical(x)||isnumeric(x));
addParameter(p,'byMonth',false,@(x)islogical(x)||isnumeric(x));
addParameter(p,'byYear',false,@(x)islogical(x)||isnumeric(x));
addParameter(p,'byDay',false,@(x)islogical(x)||isnumeric(x));
parse(p,varargin{:})

Interval   = p.Results.Interval;
isIntraday = p.Results.isIntraday;
byWeek     = p.Results.byWeek;
byMonth    = p.Results.byMonth;
byYear     = p.Results.byYear;
byDay      = p.Results.byDay;

DateSeries = unique(floor(TimeSeries));
% �γ�TimeSlots
if byWeek  %����Ϊ��λ����������
    % ���SDate��EDate֮�����е�Week��TimeSlots��Ĭ��ÿ�ܿ�ͷΪ���գ�ÿ�ܽ���Ϊ������23:59
    OpenTimeSlots = zeros(numel(DateSeries),1);
    TimeSlots     = zeros(numel(DateSeries),1);
    for iDate=1:numel(DateSeries)
        thisWeekDay   = weekday(DateSeries(iDate));
        OpenTimeSlots(iDate) = DateSeries(iDate)-(thisWeekDay-1);
        TimeSlots(iDate)     = DateSeries(iDate)+7-thisWeekDay+1-1/60/24;
    end
elseif byMonth %����Ϊ��λ����������
    % ���SDate��EDate֮�����е�Week��TimeSlots��Ĭ��ÿ�¿�ͷΪ1�գ�ÿ�½���Ϊ��ĩ
    OpenTimeSlots = zeros(numel(DateSeries),1);
    TimeSlots     = zeros(numel(DateSeries),1);
    for iDate=1:numel(DateSeries)
        OpenTimeSlots(iDate) = datenum([year(DateSeries(iDate)),month(DateSeries(iDate)),1]);
        TimeSlots(iDate)     = datenum([year(DateSeries(iDate)),month(DateSeries(iDate)),F_GetLastMonthDay(DateSeries(iDate))])+1-1/60/24;
    end
elseif byYear %����Ϊ��λ����������
    OpenTimeSlots = zeros(numel(DateSeries),1);
    TimeSlots     = zeros(numel(DateSeries),1);
    for iDate=1:numel(DateSeries)
        OpenTimeSlots(iDate) = datenum([year(DateSeries(iDate)),1,1]);
        TimeSlots(iDate)     = datenum([year(DateSeries(iDate)),12,31])+1-1/60/24;
    end
elseif byDay %�ϲ���Ƶ���������γɵ�Ƶ��������
    dateCount = 0;
    OpenTimeSlots = DateSeries(1);
    TimeSlots     = [];
    for iDate=1:numel(DateSeries)
        if dateCount>=Interval
            TimeSlots     = [TimeSlots;DateSeries(iDate-1)];
            OpenTimeSlots = [OpenTimeSlots;DateSeries(iDate)];
            dateCount    = 1;
        elseif iDate >= numel(DateSeries)
            TimeSlots     = [TimeSlots;DateSeries(iDate)];
        else
            dateCount = dateCount+1;
        end
    end
elseif isIntraday   %�������Tick��������Bar
    % ����Interval����һ���ʱ������
    TimeSeries = (0:(Interval/24/60):1)';
    % ����Data����������ʱ��Slots
    TimeSlots_Temp = repmat(TimeSeries,1,numel(DateSeries))+repmat(DateSeries',numel(TimeSeries),1);
    TimeSlots=[];
    for i=1:numel(DateSeries)
        TimeSlots=[TimeSlots;TimeSlots_Temp(:,i)]; %#ok<AGROW>
    end
    OpenTimeSlots = [0;TimeSlots(2:end)];
else  % �γ�������
    OpenTimeSlots=zeros(numel(Data.Time),1);
    TimeSlots=zeros(numel(Data.Time),1);
    for i=1:numel(Data.Time)
        if ~obj.custTime
            [TimeZone,OpenTime,SettleTime,OpenTimeOffset,Calendar] = F_LookupExchangeTime(obj,Data.Time(i),obj.Exchange,obj.Product);  % ���뽻�����Ͳ�Ʒ�����ҵõ���Ӧ��Ʒ�Ľ���ʱ��
            thisTime = obj.F_ChangeTimeZone(Data.Time(i),obj.TimeZone,TimeZone);
        else
            TimeZone   = obj.TimeZone;
            OpenTime   = obj.OpenTime;
            SettleTime = obj.SettleTime;
            OpenTimeOffset = obj.OpenTimeOffset;
            Calendar   = 'SH';
            thisTime = Data.Time(i);
        end
        [OpenTimeSlots(i),TimeSlots(i)] = F_GenerateTradeTime(obj,thisTime,OpenTime,SettleTime,OpenTimeOffset,Calendar); %����ĳһʱ��㣬�õ���ǰʱ��εĿ�����ʱ��(TimeΪ����������ʱ��)
    end
    % ����Data��ʱ������ת��
    if ~strcmpi(TimeZone,obj.TimeZone)
        OpenTimeSlots = obj.F_ChangeTimeZone(OpenTimeSlots,TimeZone,obj.TimeZone);
        TimeSlots = obj.F_ChangeTimeZone(TimeSlots,TimeZone,obj.TimeZone);
    end
end
OpenTimeSlots = unique(OpenTimeSlots);
TimeSlots     = unique(TimeSlots);
end

function lastMonthDay = F_GetLastMonthDay(date)
% get the last day of the month which 'date' is in
currentMonth = month(date);
i = 1;
while month(date+i) == currentMonth
    i=i+1;
end
lastMonthDay = day(date+i-1);
end