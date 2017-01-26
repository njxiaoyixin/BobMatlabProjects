function [ TickerSet , ContractMonth, TickerSet_Backup, LastAllowedTradeDay] = F_GenerateTicker(obj,Product,Exchange,ProductType,SDate,EDate,~)
% ��������Ĳ�Ʒ���룬�������������������ɸò�Ʒ�ڸ����������п��ܴ����ĺ�Լ����
if strcmpi(ProductType,'FUT') || strcmpi(ProductType,'INDEXFUT')
    YearVec       = year(SDate:EDate+365*2); %�������������ڵĺ����������������к�Լ
    MonthVec      = month(SDate:EDate+365*2);
    s             = [YearVec',MonthVec',zeros(numel(YearVec),4)];
    ss            = datenum(s);
    TickerMonth   = unique(ss);
    TickerSet     = cell(size(TickerMonth));
    ContractMonth = nan(size(TickerMonth));
    LastAllowedTradeDay =TickerMonth;
    for i=1:numel(TickerSet)
        TickerSet{i}     = [Product, datestr(TickerMonth(i),'yymm')];
        ContractMonth(i) = str2double(datestr(TickerMonth(i),'yymm'));
        LastAllowedTradeDay(i)      = TickerMonth(i)-10;
    end
elseif strcmpi(ProductType,'STK') || strcmpi(ProductType,'INDEX') || strcmpi(ProductType,'EDB')
    TickerSet            = {Product};
    ContractMonth        = nan;
    LastAllowedTradeDay  = nan;
end
TickerSet_Backup = TickerSet;
obj.SetProperties('TickerSet',TickerSet,'ContractMonth',ContractMonth,'TickerSet_Backup',TickerSet_Backup);

end