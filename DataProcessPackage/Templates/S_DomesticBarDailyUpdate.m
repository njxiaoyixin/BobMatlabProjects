%Daily Update
clear all
s          = WindPackage.UpdateBarPlus;
SDate      = today-10;
EDate      = today;
DataSource = 'F:/期货分钟数据';

fid=fopen([pwd,'\数据更新日志\',datestr(today,'yyyymmdd'),'.txt'],'wt+');%当有日志文件存在时进行覆盖（今日已经更新过）
TitleStr= ['日期时间：',datestr(now),'    Wind数据更新日志by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

for Date = SDate:EDate      
    if weekday(Date)==2
        ThisSDate = Date-3+15/24+1/60/24;
    elseif weekday(Date)==1 || weekday(Date)==7  %周六周日不记数据，全部推到周一
        continue
    else
        ThisSDate = Date-1+15/24+1/60/24;%从前一天下午15：01开始
    end
    ThisEDate = Date+15/24;
    s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',DataSource);
    
    disp(datestr(Date))
    TitleStr= ['现在更新：',datestr(ThisSDate),' 至 ',datestr(ThisEDate),' 的高频数据'];
    fprintf(fid,'%s\n',TitleStr);
    
    fid=s.RunFullUpdate(fid);
end
TitleStr= ['完成时间：',datestr(now),'    Wind数据更新日志by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);
fclose('all');