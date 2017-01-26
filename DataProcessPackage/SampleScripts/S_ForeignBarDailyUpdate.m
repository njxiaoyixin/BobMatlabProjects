%Daily Update
clear
load WindTradeDay

s          = BloombergPackage.UpdateBarPlus;
SDate      = today;
EDate      = today;
DataSource = 'D:/Bloomberg分钟数据';

fid=fopen([pwd,'\数据更新日志\',datestr(today,'yyyymmdd'),'_1MinBar.txt'],'wt+');%当有日志文件存在时进行覆盖（今日已经更新过）
TitleStr= ['日期时间：',datestr(now),'     Bloomberg数据更新日志by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

for Date = SDate:EDate
    [Flag,Pos] = ismember(Date,TradeDay);
    if ~Flag
        TitleStr= '现在是假期，电脑要休息啦！';
        disp(TitleStr)
        fprintf(fid,'%s\n',TitleStr);
        continue
    end
    ThisSDate = TradeDay(Pos-1)+15/24+1/60/60/24;%从前一个交易日下午15:00:01开始
    ThisEDate = Date+15/24;%到当天15：00结束
    s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',DataSource);
    
    disp(datestr(Date))
    TitleStr= ['现在更新：',datestr(ThisSDate),' 至 ',datestr(ThisEDate),' 的分钟数据'];
    fprintf(fid,'%s\n',TitleStr);
    
    fid=s.RunFullUpdate(fid);
end
fprintf(fid,'%s\n','今日更新完成！');
fclose('all');