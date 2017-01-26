function DataOut   = F_LoadBar(obj,Data,varargin)
% 这里Exchange只影响交易时间的生成
% custTime为自定义开收盘时间开关，如果custTime为正，则obj中的OpenTime以及SettleTime设置开收盘时间

%设置默认参数
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

addRequired(p,'Data',@isstruct);
addParameter(p,'isIntraday',false,@(x)islogical(x)||isnumeric(x));
parse(p,Data,varargin{:})
isIntraday = p.Results.isIntraday;

% 生成TimeSlots
[OpenTimeSlots,TimeSlots]=F_GenerateTimeSlots(obj,Data.Time,varargin{:});

% 转换数据
DataOut = F_FreqTrans(obj,Data,isIntraday,OpenTimeSlots,TimeSlots);
end

