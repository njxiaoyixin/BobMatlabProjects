function [SDate,EDate] = F_GenerateTradeTime_1(obj,Date,Exchange,TimeZone,OpenTime,SettleTime,OpenTimeOffset)
% 输入单日日期，得出该结算日的交易时间
% 可指定开收盘时间（输入目标时区的时间）
if nargin <5
    OpenTimeOffset = -1;
end
if nargin <4
    TimeZone = obj.TimeZone;
end
if nargin <3
    Exchange = obj.Exchange;
end

if weekday(Date)==2  %如果是周一，要从上周五晚上开始
    if mod(Date,1) > SettleTime %结束日为下一天
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


SDate = floor(Date)+OpenTimeOffset+OpenTime;
SDate = floor(Date)+SettleTime;




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