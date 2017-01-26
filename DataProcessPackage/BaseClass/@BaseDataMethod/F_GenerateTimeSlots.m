function [OpenTimeSlots,TimeSlots]=F_GenerateTimeSlots(obj,TimeSeries,varargin)
% TimeSeries is vector that contains time

%设置默认参数
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

% 默认是合成1天的数据
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
% 形成TimeSlots
if byWeek  %以周为单位连接日数据
    % 输出SDate和EDate之间所有的Week的TimeSlots，默认每周开头为周日，每周结束为周六晚23:59
    OpenTimeSlots = zeros(numel(DateSeries),1);
    TimeSlots     = zeros(numel(DateSeries),1);
    for iDate=1:numel(DateSeries)
        thisWeekDay   = weekday(DateSeries(iDate));
        OpenTimeSlots(iDate) = DateSeries(iDate)-(thisWeekDay-1);
        TimeSlots(iDate)     = DateSeries(iDate)+7-thisWeekDay+1-1/60/24;
    end
elseif byMonth %以月为单位连接日数据
    % 输出SDate和EDate之间所有的Week的TimeSlots，默认每月开头为1日，每月结束为月末
    OpenTimeSlots = zeros(numel(DateSeries),1);
    TimeSlots     = zeros(numel(DateSeries),1);
    for iDate=1:numel(DateSeries)
        OpenTimeSlots(iDate) = datenum([year(DateSeries(iDate)),month(DateSeries(iDate)),1]);
        TimeSlots(iDate)     = datenum([year(DateSeries(iDate)),month(DateSeries(iDate)),F_GetLastMonthDay(DateSeries(iDate))])+1-1/60/24;
    end
elseif byYear %以年为单位连接日数据
    OpenTimeSlots = zeros(numel(DateSeries),1);
    TimeSlots     = zeros(numel(DateSeries),1);
    for iDate=1:numel(DateSeries)
        OpenTimeSlots(iDate) = datenum([year(DateSeries(iDate)),1,1]);
        TimeSlots(iDate)     = datenum([year(DateSeries(iDate)),12,31])+1-1/60/24;
    end
elseif byDay %合并高频率日数据形成低频率日数据
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
elseif isIntraday   %如果是用Tick处理日内Bar
    % 根据Interval生成一天的时间序列
    TimeSeries = (0:(Interval/24/60):1)';
    % 根据Data的日期生成时间Slots
    TimeSlots_Temp = repmat(TimeSeries,1,numel(DateSeries))+repmat(DateSeries',numel(TimeSeries),1);
    TimeSlots=[];
    for i=1:numel(DateSeries)
        TimeSlots=[TimeSlots;TimeSlots_Temp(:,i)]; %#ok<AGROW>
    end
    OpenTimeSlots = [0;TimeSlots(2:end)];
else  % 形成日数据
    OpenTimeSlots=zeros(numel(Data.Time),1);
    TimeSlots=zeros(numel(Data.Time),1);
    for i=1:numel(Data.Time)
        if ~obj.custTime
            [TimeZone,OpenTime,SettleTime,OpenTimeOffset,Calendar] = F_LookupExchangeTime(obj,Data.Time(i),obj.Exchange,obj.Product);  % 输入交易所和产品，查找得到相应产品的交易时间
            thisTime = obj.F_ChangeTimeZone(Data.Time(i),obj.TimeZone,TimeZone);
        else
            TimeZone   = obj.TimeZone;
            OpenTime   = obj.OpenTime;
            SettleTime = obj.SettleTime;
            OpenTimeOffset = obj.OpenTimeOffset;
            Calendar   = 'SH';
            thisTime = Data.Time(i);
        end
        [OpenTimeSlots(i),TimeSlots(i)] = F_GenerateTradeTime(obj,thisTime,OpenTime,SettleTime,OpenTimeOffset,Calendar); %输入某一时间点，得到当前时间段的开收盘时间(Time为交易所当地时间)
    end
    % 根据Data的时区进行转换
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