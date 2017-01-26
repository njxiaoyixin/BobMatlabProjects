 function [ TickerSet , ContractMonth, TickerSet_Backup , LastAllowedTradeDay] = F_GenerateTicker(obj,Product,Exchange,ProductType,SDate,EDate,Country,Product_Backup)
            %%
            if nargin < 8
                Product_Backup=[];
            end
            
            if nargin < 7
                Country='US';
            end
            
            if strcmpi(ProductType,'FUT') || strcmpi(ProductType,'INDEXFUT')
                YearVec            = year(SDate:EDate+365*2); %推算至结束日期的后两年所存续的所有合约
                MonthVec           = month(SDate:EDate+365*2);
                s                  = [YearVec',MonthVec',zeros(numel(YearVec),4)];
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
                    TickerSet{i}            = ['F.',Country,'.',Product,TickerMonthF{i},DoubleYear]; %GCG16 Comdty
                    ContractMonth(i)        = str2double(datestr(TickerMonth(i),'yymm'));
                    LastAllowedTradeDay(i)  = TickerMonth(i)-10;
                    if ~isempty(Product_Backup)
                        TickerSet{i}        =[Product_Backup,TickerMonthF{i},DoubleYear]; %GCG16 Comdty
                    end
                end
            elseif strcmpi(ProductType,'FUT A')
                
            elseif strcmpi(ProductType,'INDEXFUT A')
                
            elseif strcmpi(ProductType,'FUT 1')
                
            elseif strcmpi(ProductType,'INDEXFUT 2')
                
            elseif strcmpi(ProductType,'FUT 2')
                
            elseif strcmpi(ProductType,'INDEXFUT 2')
                
            elseif strcmpi(ProductType,'STK')
                
            elseif strcmpi(ProductType,'INDEX')
                
            elseif strcmpi(ProductType,'CURNCY')
                
            end
            obj.SetProperties('TickerSet',TickerSet,'ContractMonth',ContractMonth);
        end