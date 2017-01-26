function [STime,ETime] = F_GenerateTradeTime(obj,Time,OpenTime,SettleTime,OpenTimeOffset,Calendar)
%输入某一时间点，得到当前时间段的开收盘时间
% 可指定开收盘时间（输入目标时区的时间）
% Time必须与OpenTime和SettleTime同一时区
if nargin <6
    Calendar = 'SH';
end
if nargin <5
    OpenTimeOffset = -1;
end
if nargin <4
    SettleTime = obj.SettleTime;
end
if nargin <3
    OpenTime = obj.OpenTime;
end
if nargin < 2
    error('Please Input Date into function F_GenerateTradeTime')
end

if ~evalin('base','exist(''TradeDay'',''var'')')
    evalin('base','load TradeDay');
end
TradeDay = evalin('base','TradeDay');

thisTradeDay = TradeDay.(Calendar);

% 根据SettleTime来划分时间点，如果Time小于SettleTime，则归属于本交易日,如果Time大于SettleTime，则归属于下一交易日
STime = nan(size(Time));
ETime = nan(size(Time));
if ischar(OpenTime)
    OpenTime = mod(datenum(OpenTime),1);
end
if ischar(SettleTime)
    SettleTime = mod(datenum(SettleTime),1);
end

% thisTime = obj.F_ChangeTimeZone(Time,TargetTimeZone,TimeZone);

for i=1:numel(Time)
    idx = find(thisTradeDay<=Time(i),1,'last');
    if mod(Time,1)<= datenum(SettleTime)
        % 属于当前交易日
        thisDateId = idx;
    else
        % 属于下一交易日
        thisDateId = idx+1;
    end
    
    STime(i) = thisTradeDay(thisDateId+OpenTimeOffset)+OpenTime;
    ETime(i) = thisTradeDay(thisDateId)+SettleTime;
end
% STime = obj.F_ChangeTimeZone(STime,TimeZone,TargetTimeZone);
% ETime = obj.F_ChangeTimeZone(ETime,TimeZone,TargetTimeZone);

%{
if strcmpi(Exchange,'CB')
    %原始交易时间(默认TimeZone为'CST')
    if numel(Date) > 1 || isempty(Date)
        error('Please Input the Right Single Date!')
    end
    STime = 19/24+1/24/60;
    ETime = 19/24;
    %调整时区
    STime = mod(obj.F_ChangeTimeZone(STime,'CST',TimeZone),1);
    ETime = mod(obj.F_ChangeTimeZone(ETime,'CST',TimeZone),1);
    if OpenTimeOffset==-1
        SDate = floor(Date)-1+STime;
        EDate = floor(Date)+ETime;
    else
        SDate = floor(Date)+STime;
        EDate = floor(Date)+ETime;
    end
elseif (strcmpi(Exchange,'CM') || strcmpi(Exchange,'NM'))
    %原始交易时间(默认TimeZone为'EST')
    if numel(Date) > 1 || isempty(Date)
        error('Please Input the Right Single Date!')
    end
    STime = 15/24+1/24/60;
    ETime = 15/24;
    %调整时区
    STime = mod(obj.F_ChangeTimeZone(STime,'EST',TimeZone),1);
    ETime = mod(obj.F_ChangeTimeZone(ETime,'EST',TimeZone),1);
    if OpenTimeOffset==-1
        SDate = floor(Date)-1+STime;
        EDate = floor(Date)+ETime;
    else
        SDate = floor(Date)+STime;
        EDate = floor(Date)+ETime;
    end
else %以国内时间来决定
    if numel(Date) > 1 || isempty(Date)
        error('Please Input the Right Single Date!')
    end
    if weekday(Date)==2  %如果是周一，要从上周五晚上开始
        if mod(Date,1) > 16/24 %结束日为下一天
            ThisEDate = floor(Date)+1;
            ThisSDate = floor(Date);
        else
            ThisEDate = floor(Date);
            ThisSDate = floor(Date)-3;
        end
    elseif weekday(Date) ==6 %如果是周五，EDate要推到下周一
        if mod(Date,1) > 16/24 %结束日为下一天
            ThisEDate = floor(Date)+3;
            ThisSDate = floor(Date);
        else
            ThisEDate = floor(Date);
            ThisSDate = floor(Date)-1;
        end
    else
        if mod(Date,1) > 16/24 %结束日为下一天
            ThisEDate = floor(Date)+1;
            ThisSDate = floor(Date);
        else
            ThisEDate = floor(Date);
            ThisSDate = floor(Date)-1;
        end
    end
    SDate = ThisSDate + 21/24;
    EDate = ThisEDate + 16/24;
end
if nargin >=5
    SDate = floor(SDate)+OpenTime;
end
if nargin >=6
    EDate = floor(SDate)+SettleTime;
end
end
%}