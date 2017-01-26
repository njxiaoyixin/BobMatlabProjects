function [TimeZone,OpenTime,SettleTime,OpenTimeOffset,Calendar] = F_LookupExchangeTime(obj,Date,Exchange,Product)  % 输入交易所和产品，查找得到相应产品的交易时间
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
    case {'SG'} % 新加坡交易所
        Calendar = 'SH';
    case {'HK'} % 港交所
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
    case {'SF'} % 中金所2016年1月1日开始为9点半开盘，15点收盘，之前为9点15开盘，15点15收盘
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
    case {'SH','SZ'} %沪深交易所
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