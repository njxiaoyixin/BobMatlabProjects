function [ TickerSet , ContractMonth, TickerSet_Backup, LastAllowedTradeDay] = F_GenerateTicker(obj,Product,Exchange,ProductType,SDate,EDate,~)
% 根据输入的产品代码，交易所和日期区间生成该产品在该区间内所有可能存续的合约代码
if strcmpi(ProductType,'FUT') || strcmpi(ProductType,'INDEXFUT')
    YearVec       = year(SDate:EDate+365*2); %推算至结束日期的后两年所存续的所有合约
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