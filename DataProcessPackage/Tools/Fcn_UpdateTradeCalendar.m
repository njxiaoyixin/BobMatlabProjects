function Fcn_UpdateTradeCalendar()
w=windmatlab;
EDate=datenum([year(today)+1,12,31]);
[GlobalTradeDay.SH]=w.tdays('2000-01-01',datestr(EDate));
[GlobalTradeDay.NYSE]=w.tdays('2000-01-01',datestr(EDate),'TradingCalendar=NYSE');
[GlobalTradeDay.NYMEX]=w.tdays('2000-01-01',datestr(EDate),'TradingCalendar=NYMEX');
[GlobalTradeDay.COMEX]=w.tdays('2000-01-01',datestr(EDate),'TradingCalendar=CBOT');
[GlobalTradeDay.CBOT]=w.tdays('2000-01-01',datestr(EDate),'TradingCalendar=CBOT');
[GlobalTradeDay.HKEX]=w.tdays('2000-01-01',datestr(EDate),'TradingCalendar=HKEX');

fields=  fieldnames(GlobalTradeDay);
for i=1:numel(fields)
    GlobalTradeDay.(fields{i}) = datenum(GlobalTradeDay.(fields{i}));
end
save Config\GlobalTradeDay GlobalTradeDay
end