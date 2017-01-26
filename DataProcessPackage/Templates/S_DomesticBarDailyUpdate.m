%Daily Update
clear all
s          = WindPackage.UpdateBarPlus;
SDate      = today-10;
EDate      = today;
DataSource = 'F:/�ڻ���������';

fid=fopen([pwd,'\���ݸ�����־\',datestr(today,'yyyymmdd'),'.txt'],'wt+');%������־�ļ�����ʱ���и��ǣ������Ѿ����¹���
TitleStr= ['����ʱ�䣺',datestr(now),'    Wind���ݸ�����־by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

for Date = SDate:EDate      
    if weekday(Date)==2
        ThisSDate = Date-3+15/24+1/60/24;
    elseif weekday(Date)==1 || weekday(Date)==7  %�������ղ������ݣ�ȫ���Ƶ���һ
        continue
    else
        ThisSDate = Date-1+15/24+1/60/24;%��ǰһ������15��01��ʼ
    end
    ThisEDate = Date+15/24;
    s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',DataSource);
    
    disp(datestr(Date))
    TitleStr= ['���ڸ��£�',datestr(ThisSDate),' �� ',datestr(ThisEDate),' �ĸ�Ƶ����'];
    fprintf(fid,'%s\n',TitleStr);
    
    fid=s.RunFullUpdate(fid);
end
TitleStr= ['���ʱ�䣺',datestr(now),'    Wind���ݸ�����־by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);
fclose('all');