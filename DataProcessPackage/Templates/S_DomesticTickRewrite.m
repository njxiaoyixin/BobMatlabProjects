
%��ȡCSV�ļ�����CSV�ļ���fopen(,'r+t')����ʽ���±��棨֮ǰ��r+��

%Daily Update
clear

%��ȡ������
% w=windmatlab;
% [TradeDay,~,~,~,~,~]=w.tdays('1990-01-01','2017-02-01');
% TradeDay=datenum(TradeDay);
% save WindTradeDay TradeDay;
load GlobalTradeDay.mat
TradeDay = GlobalTradeDay.SH;

s          = WindPackage.UpdateTickPlus;
SDate      = datenum('2016-1-1');
EDate      = today-1;
DataSource = 'F:/�ڻ��ֱ�����';

CodeMap=WindPackage.WindCtrInfo.GetFullCodeMap;
Product_List     = CodeMap.Product;
Exchange_List    = CodeMap.Exchange;
ProductType_List = CodeMap.ProductType;

for Date = SDate:EDate
    disp(datestr(Date,'yyyy-mm-dd'))
    [Flag,Pos] = ismember(Date,TradeDay);
    if ~Flag
        TitleStr= '�����Ǽ��ڣ�����Ҫ��Ϣ����';
        disp(TitleStr)
        continue
    end
    ThisSDate = TradeDay(Pos-1)+15/24+1/60/60/24;%��ǰһ������������15:00:01��ʼ
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
                        Dir2(1) = 'E';  %��F�̵������������쵽E��
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

disp('����ת����ɣ�')