function [TimeZone,OpenTime,SettleTime,OpenTimeOffset,Calendar] = F_LookupExchangeTime(obj,Date,Exchange,Product)  % ���뽻�����Ͳ�Ʒ�����ҵõ���Ӧ��Ʒ�Ľ���ʱ��
switch Exchange
    case {'CB'}
        OpenTime = '19:01:00';
        SettleTime = '18:59:00';
        OpenTimeOffset = -1;
        TimeZone = 'CST';
        Calendar = 'CBOT';
    case {'CM','NM'}
        OpenTime = '18:01:00';
        SettleTime = '16:59:00';
        OpenTimeOffset = -1;
        TimeZone = 'EST';
        if strcmpi(Exchange,'NM')
            Calendar = 'NYMEX';
        else
            Calendar = 'COMEX';
        end
    case {'NY'}
        OpenTime = '9:30:00';
        SettleTime = '15:59:00';
        OpenTimeOffset = -1;
        TimeZone = 'EST';
        Calendar = 'NYSE';
    case {'SG'} % �¼��½�����
        Calendar = 'SH';
    case {'HK'} % �۽���
        if nargin < 4
            Product = 'HSI';
        end
        switch Product
            case {'HHI','HSI'}
                OpenTime = '9:15:00';
                SettleTime = '16:14:00';
                OpenTimeOffset = -1;
            otherwise
                OpenTime = '9:30:00';
                SettleTime = '15:59:00';
                OpenTimeOffset = 0;
        end
        TimeZone = 'CN';
        Calendar = 'HKEX';
    case {'SF'} % �н���2016��1��1�տ�ʼΪ9��뿪�̣�15�����̣�֮ǰΪ9��15���̣�15��15����
        if floor(Date) < datenum('2016-1-1')
            OpenTime = '9:15:00';
            SettleTime = '15:14:00';
        else
            OpenTime = '9:30:00';
            SettleTime = '14:59:00';
        end
        OpenTimeOffset = 0;
        TimeZone = 'CN';
        Calendar = 'SH';
    case {'SH','SZ'} %�������
        OpenTime = '9:30:00';
        SettleTime = '14:59:00';
        OpenTimeOffset = 0;
        TimeZone = 'CN';
        Calendar = 'SH';
    case {'SQ','DL','ZZ'}
        OpenTime = '21:00:00';
        SettleTime = '14:59:00';
        OpenTimeOffset = -1;
        TimeZone = 'CN';
        Calendar = 'SH';
    otherwise
        OpenTime = '9:30:00';
        SettleTime = '14:59:00';
        OpenTimeOffset = 0;
        TimeZone = 'CN';
        Calendar = 'SH';
end
            
end