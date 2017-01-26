
%读取CSV文件，将CSV文件以fopen(,'r+t')的形式重新保存（之前是r+）

%Daily Update
clear

%获取交易日
% w=windmatlab;
% [TradeDay,~,~,~,~,~]=w.tdays('1990-01-01','2017-02-01');
% TradeDay=datenum(TradeDay);
% save WindTradeDay TradeDay;
load GlobalTradeDay.mat
TradeDay = GlobalTradeDay.SH;

s          = WindPackage.UpdateTickPlus;
SDate      = datenum('2016-1-1');
EDate      = today-1;
DataSource = 'F:/期货分笔数据';

CodeMap=WindPackage.WindCtrInfo.GetFullCodeMap;
Product_List     = CodeMap.Product;
Exchange_List    = CodeMap.Exchange;
ProductType_List = CodeMap.ProductType;

for Date = SDate:EDate
    disp(datestr(Date,'yyyy-mm-dd'))
    [Flag,Pos] = ismember(Date,TradeDay);
    if ~Flag
        TitleStr= '现在是假期，电脑要休息啦！';
        disp(TitleStr)
        continue
    end
    ThisSDate = TradeDay(Pos-1)+15/24+1/60/60/24;%从前一个交易日下午15:00:01开始
    ThisEDate = Date+15/24;
    s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',DataSource);
    
    for i=1:numel(CodeMap.Product)
        if ~isnan(CodeMap.Product{i})
            [ ThisTickerSet ]=s.F_GenerateTicker(Product_List{i},Exchange_List{i},ProductType_List{i},s.SDate,s.EDate);
            s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TickerSet',ThisTickerSet);
            [ExistFlag,Dir] = s.F_FolderExist(floor(s.EDate),s.Exchange,s.DataSource);
            if ExistFlag
                for j=1:numel(s.TickerSet)
                    FileName=[Dir,'/',upper(s.Exchange),lower(s.TickerSet{j}),'.csv'];
                    if exist(FileName,'file')
                        Data = s.F_ReadTickFrom_CSV_Original(FileName);
                        Dir2 = Dir;
                        Dir2(1) = 'E';  %把F盘的数据重新制造到E盘
                        if ~exist(Dir2,'dir')
                            mkdir(Dir2);
                        end
                        FileName2 = [Dir2,'/',upper(s.Exchange),lower(s.TickerSet{j}),'.csv'];
                        if ~isempty(Data)
                            s.F_WriteCSV(FileName2,Data,1);
                        end
                    end
                end
            end
        end
    end
end

disp('数据转换完成！')