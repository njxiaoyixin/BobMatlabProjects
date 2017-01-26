%Connect to BBG Server
rehash
Dir = [pwd,'\数据更新日志\FTP下载日志\'];
if ~exist(Dir,'dir')
    mkdir(Dir)
end
fid=fopen([Dir,datestr(today,'yyyymmdd'),'.txt'],'wt+');%当有日志文件存在时进行覆盖（今日已经更新过）
TitleStr= ['日期时间：',datestr(now),'    BBG FTP下载日志by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

fprintf(fid,'%s\n','Connecting to FTP Server...');
try
    FTP_Client = ftp('10.200.1.109:21','guest','');
catch Err
    fprintf(fid,'%s\n',Err.message);
    fclose('all');
    error('Connecting Error Exit!')
end
TitleStr= 'FTP连接成功！';
fprintf(fid,'%s\n',TitleStr);

SDate = today();
EDate = today();
% SDate = datenum('2016-9-19');
% EDate = datenum('2016-9-19');
TargetFolder = 'F:\Bloomberg分钟数据';
if ~exist(TargetFolder,'dir')
    mkdir(TargetFolder);
end
load GlobalTradeDay.mat
TradeDay = GlobalTradeDay.SH;

for Date = SDate:EDate
    TitleStr= ['开始尝试下载',datestr(Date),'的数据'];
    fprintf(fid,'%s\n',TitleStr);
    disp(datestr(Date))
    [Flag,Pos] = ismember(Date,TradeDay);
    if ~Flag
        TitleStr= '  这天是假期，电脑要休息啦！';
        disp(TitleStr)
        fprintf(fid,'%s\n',TitleStr);
        continue
    end
    YearStr = num2str(year(Date));
    DateStr = datestr(Date,'yyyymmdd');
    w=dir(FTP_Client,YearStr);
    Check=0;
    for i=1:numel(w)
        if strcmpi(DateStr,w(i).name)
            %if Exist Download Folder
            TitleStr= '  文件存在!判断是否有本地文件';
            fprintf(fid,'%s\n',TitleStr);
            %如果本地文件存在，则删除本地文件并进行覆盖
            LocalDir=[TargetFolder,'/',YearStr,'/',DateStr];
            if exist(LocalDir,'dir')
                TitleStr= '  本地文件存在，删除本地文件...';
                fprintf(fid,'%s\n',TitleStr);
                [SUCCESS,MESSAGE,MESSAGEID] = rmdir(LocalDir,'s');
                TitleStr= '  本地文件删除完毕!开始下载...';
                fprintf(fid,'%s\n',TitleStr);
%             continue  %如果本地文件存在，不下载
            end
            %开始下载
            TitleStr= '  开始下载...';
            fprintf(fid,'%s\n',TitleStr);
            try
                mget(FTP_Client,[YearStr,'/',w(i).name],TargetFolder);
            catch Err
                fprintf(fid,'%s\n',Err.message);
            end
            TitleStr= [DateStr,'  下载完毕！'];
            fprintf(fid,'%s\n',TitleStr);
            Check=1;
            break
        end
    end
    if Check~=1
        TitleStr= '  服务器上无该日数据，结束该日下载！';
        fprintf(fid,'%s\n',TitleStr);
    end
end

TitleStr= '所有数据下载结束,关闭连接!';
fprintf(fid,'%s\n',TitleStr);
close(FTP_Client)
fclose('all');


subject = [datestr(now,31),'海外Bar数据已下载完毕'];
content = '本日海外Bar数据已下载完毕，请查看';
mail2me(subject,content)
