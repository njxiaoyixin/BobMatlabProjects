%Daily Update
clear
load WindTradeDay

s          = BloombergPackage.UpdateBarPlus;
SDate      = today;
EDate      = today;
DataSource = 'D:/Bloomberg��������';

fid=fopen([pwd,'\���ݸ�����־\',datestr(today,'yyyymmdd'),'_1MinBar.txt'],'wt+');%������־�ļ�����ʱ���и��ǣ������Ѿ����¹���
TitleStr= ['����ʱ�䣺',datestr(now),'     Bloomberg���ݸ�����־by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

for Date = SDate:EDate
    [Flag,Pos] = ismember(Date,TradeDay);
    if ~Flag
        TitleStr= '�����Ǽ��ڣ�����Ҫ��Ϣ����';
        disp(TitleStr)
        fprintf(fid,'%s\n',TitleStr);
        continue
    end
    ThisSDate = TradeDay(Pos-1)+15/24+1/60/60/24;%��ǰһ������������15:00:01��ʼ
    ThisEDate = Date+15/24;%������15��00����
    s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',DataSource);
    
    disp(datestr(Date))
    TitleStr= ['���ڸ��£�',datestr(ThisSDate),' �� ',datestr(ThisEDate),' �ķ�������'];
    fprintf(fid,'%s\n',TitleStr);
    
    fid=s.RunFullUpdate(fid);
end
fprintf(fid,'%s\n','���ո�����ɣ�');
fclose('all');