function DataOut   = F_LoadBar(obj,Data,varargin)
% ����ExchangeֻӰ�콻��ʱ�������
% custTimeΪ�Զ��忪����ʱ�俪�أ����custTimeΪ������obj�е�OpenTime�Լ�SettleTime���ÿ�����ʱ��

%����Ĭ�ϲ���
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���

addRequired(p,'Data',@isstruct);
addParameter(p,'isIntraday',false,@(x)islogical(x)||isnumeric(x));
parse(p,Data,varargin{:})
isIntraday = p.Results.isIntraday;

% ����TimeSlots
[OpenTimeSlots,TimeSlots]=F_GenerateTimeSlots(obj,Data.Time,varargin{:});

% ת������
DataOut = F_FreqTrans(obj,Data,isIntraday,OpenTimeSlots,TimeSlots);
end

