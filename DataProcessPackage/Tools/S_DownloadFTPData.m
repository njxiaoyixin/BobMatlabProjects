%Connect to BBG Server
function S_DownloadFTPData(varargin)
run PathSetting_DataProcess

p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

valid_dataProvider  = {'CQG','Wind','Bloomberg'};
valid_dataType      = {'tick','bar','daily','EDB'};
valid_fileType      = {'ts','csv','mat'};
addParameter(p,'DataProvider','Wind',@(x)any(validatestring(upper(x),upper(valid_dataProvider))));    %可以去掉
addParameter(p,'InputType','Tick',@(x)any(validatestring(upper(x),upper(valid_dataType))));    %可以去掉
addParameter(p,'OutputType','Tick',@(x)any(validatestring(upper(x),upper(valid_dataType))));   %可以去掉
addParameter(p,'InputFileType','csv',@(x)any(validatestring(upper(x),upper(valid_fileType))));
addParameter(p,'OutputFileType','mat',@(x)any(validatestring(upper(x),upper(valid_fileType))));
addParameter(p,'TransformData',true,@(x)islogical(x)||isnumerical(x));
parse(p,varargin{:})

% 手动参数
DataProvider = p.Results.DataProvider ;
InputType    = p.Results.InputType;
OutputType   = p.Results.OutputType;
InputFileType = p.Results.InputFileType;
OutputFileType = p.Results.OutputFileType;
transformData = p.Results.TransformData;
%  -----------从XML读取配置参数--------------
Pref.ReadSpec  = false;
Pref.Str2Num   = 'never';
Info=xml_read('Config\GlobalConfig.xml',Pref);
DataProviders = {Info.DataProvider};
Freqs = {Info.Freq};
Intervals = {Info.Interval};
FileType  = {Info.FileType};
% csv数据更新目录
flag1  = strcmpi(DataProviders,DataProvider)&strcmpi(Freqs,InputType)&strcmpi(FileType,InputFileType);
csvDir = Info(flag1).Download.TargetFolder;
SDate=F_ReadXMLdate(Info(flag1).Download.SDate);
EDate=F_ReadXMLdate(Info(flag1).Download.EDate);
% mat数据更新目录
flag2 = strcmpi(DataProviders,DataProvider)&strcmpi(Freqs,InputType)&strcmpi(FileType,OutputFileType);
matDir = Info(flag2).Update.DataSource;

LogPath = Info(flag1).Download.LogPath;
if ~exist(LogPath,'dir')
    mkdir(LogPath)
end
IP = Info(flag1).Download.IP;
Username = Info(flag1).Download.Username;
Password = Info(flag1).Download.Password;
%---------------------------------

fid=fopen(fullfile(LogPath,[datestr(today,'yyyymmdd'),'_DownloadWindTick.txt']),'wt+');%当有日志文件存在时进行覆盖（今日已经更新过）
TitleStr= ['日期时间：',datestr(now),'    WindTick FTP下载日志  by Yixin Xiao  '];
fprintf(fid,'%s\n',TitleStr);

fprintf(fid,'%s\n','Connecting to FTP Server...');
try
    FTP_Client = ftp(IP,Username,Password);
catch Err
    fprintf(fid,'%s\n',Err.message);
    fclose('all');
    return
end
TitleStr= 'FTP连接成功！';
fprintf(fid,'%s\n',TitleStr);

if ~exist(csvDir,'dir')
    mkdir(csvDir);
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
            LocalDir=[csvDir,'/',YearStr,'/',DateStr];
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
                mget(FTP_Client,[YearStr,'/',w(i).name],csvDir);
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
    else
        if transformData
        % 将CSV数据转换成Mat
        TitleStr= '  将CSV数据转换成mat...';
        fprintf(fid,'%s\n',TitleStr);
        WorkScripts.TranslateDomesticCSVtoMAT(Date,Date,'TargetFolder',matDir,'DataSource',csvDir,'InputType',InputType,'OutputType',OutputType);
        end
    end
end

TitleStr= '所有数据下载结束,关闭连接!';
fprintf(fid,'%s\n',TitleStr);
close(FTP_Client)
fclose('all');

subject = [datestr(now,31),'本日 ',DataProvider,' ',InputType,' 数据已下载完毕，请查看'];
content = [datestr(now,31),'本日 ',DataProvider,' ',InputType,' 数据已下载完毕，请查看'];
mail2me(subject,content)
end

