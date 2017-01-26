function [ TickerSet , ContractMonth, TickerSet_Backup,LastAllowedTradeDay] = F_GenerateTicker(obj,Product,Exchange,ProductType,SDate,EDate,Country)
%%
if nargin < 7
    Country='US';
end

if strcmpi(ProductType,'FUT') || strcmpi(ProductType,'INDEXFUT')
    YearVec            = year(SDate:EDate+365*2); %推算至结束日期的后两年所存续的所有合约
    MonthVec           = month(SDate:EDate+365*2);
    s                  = [YearVec',MonthVec',ones(numel(YearVec),1),zeros(numel(YearVec),3)];
    ss                 = datenum(s);
    TickerMonth        = unique(ss);
    TickerSet          = cell(size(TickerMonth));
    TickerSet_Backup   = cell(size(TickerMonth));
    ContractMonth      = nan(size(TickerMonth));
    
    TickerMonthF=cell(size(TickerMonth));
    LastAllowedTradeDay = TickerMonth;
    for i=1:numel(TickerMonth)%将数字月份转换成字母
        switch month(TickerMonth(i))
            case 1
                TickerMonthF{i}='F';
            case 2
                TickerMonthF{i}='G';
            case 3
                TickerMonthF{i}='H';
            case 4
                TickerMonthF{i}='J';
            case 5
                TickerMonthF{i}='K';
            case 6
                TickerMonthF{i}='M';
            case 7
                TickerMonthF{i}='N';
            case 8
                TickerMonthF{i}='Q';
            case 9
                TickerMonthF{i}='U';
            case 10
                TickerMonthF{i}='V';
            case 11
                TickerMonthF{i}='X';
            case 12
                TickerMonthF{i}='Z';
        end
    end
    for i=1:numel(TickerSet)%生成TickerSet与FileNameSet
        DoubleYear=datestr(TickerMonth(i),'yy');
        SingleYear=DoubleYear(2);
        if strcmpi(ProductType,'FUT')
            TickerSet{i}            =[Product,TickerMonthF{i},DoubleYear,' COMDTY']; %GCG16 Comdty
            TickerSet_Backup{i}     =[Product,TickerMonthF{i},SingleYear,' COMDTY']; %GCG16 Comdty
        elseif strcmpi(ProductType,'INDEXFUT')
            TickerSet{i}            =[Product,TickerMonthF{i},DoubleYear,' INDEX']; %GCG16 Comdty
            TickerSet_Backup{i}     =[Product,TickerMonthF{i},SingleYear,' INDEX']; %GCG16 Comdty
        end
        ContractMonth(i)            = str2double(datestr(TickerMonth(i),'yymm'));
        LastAllowedTradeDay(i)      = TickerMonth(i)-10;
    end
elseif strcmpi(ProductType,'FUT A')
    TickerSet        ={[Product,'A COMDTY']}; %CU1 Comdty
    TickerSet_Backup ={[Product,'A COMDTY']}; %CU1 Comdty
    ContractMonth    = nan;
    LastAllowedTradeDay = nan;
elseif strcmpi(ProductType,'INDEXFUT A')
    TickerSet        ={[Product,'A INDEX']}; %XU1 Comdty
    TickerSet_Backup ={[Product,'A INDEX']}; %XU1 Comdty
    ContractMonth    = nan;
    LastAllowedTradeDay = nan;
elseif strcmpi(ProductType,'FUT 1')
    TickerSet        ={[Product,'1 COMDTY']}; %CU1 Comdty
    TickerSet_Backup ={[Product,'1 COMDTY']}; %CU1 Comdty
    ContractMonth    = nan;
    LastAllowedTradeDay = nan;
elseif strcmpi(ProductType,'INDEXFUT 2')
    TickerSet        ={[Product,'1 INDEX']}; %XU1 Comdty
    TickerSet_Backup ={[Product,'1 INDEX']}; %XU1 Comdty
    ContractMonth    = nan;
    LastAllowedTradeDay = nan;
elseif strcmpi(ProductType,'FUT 2')
    TickerSet        ={[Product,'2 COMDTY']}; %CU1 Comdty
    TickerSet_Backup ={[Product,'2 COMDTY']}; %CU1 Comdty
    ContractMonth    = nan;
    LastAllowedTradeDay = nan;
elseif strcmpi(ProductType,'INDEXFUT 2')
    TickerSet        ={[Product,'2 INDEX']}; %XU1 Comdty
    TickerSet_Backup ={[Product,'2 INDEX']}; %XU1 Comdty
    ContractMonth    = nan;
    LastAllowedTradeDay = nan;
elseif strcmpi(ProductType,'STK')
    TickerSet        ={[Product,' ',Country,' EQUITY']}; %MKSFT US EQUITY
    TickerSet_Backup ={[Product,' ',Country,' EQUITY']}; %MKSFT US EQUITY
    ContractMonth    = nan;
    LastAllowedTradeDay = nan;
elseif strcmpi(ProductType,'INDEX')
    TickerSet        ={[Product,' INDEX']}; %XIN9I INDEX
    TickerSet_Backup ={[Product,' INDEX']}; %XIN9I INDEX
    ContractMonth    = nan;
    LastAllowedTradeDay = nan;
elseif strcmpi(ProductType,'CURNCY')
    TickerSet        ={[Product,' CURNCY']}; %USDCNH CURNCY
    TickerSet_Backup ={[Product,' CURNCY']}; %USDCNH CURNCY
    ContractMonth    = nan;
    LastAllowedTradeDay = nan;
end
obj.SetProperties('TickerSet',TickerSet,'ContractMonth',ContractMonth);
end