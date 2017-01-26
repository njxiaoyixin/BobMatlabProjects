%Daily Update
function S_DomesticEDBUpdate(varargin)
addpath(genpath(pwd))

p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数
addParameter(p,'byDay',false,@(x)islogical(x)||isnumerical(x));
parse(p,varargin{:});

byDay = p.Results.byDay;

%获取交易日
load GlobalTradeDay.mat
TradeDay = GlobalTradeDay.SH;
addpath(genpath('F:\工作文件\策略研究\商品期货\商品期货多因子\Codes\LTFactorModel'))

%  -----------从XML读取配置参数--------------
Pref.ReadSpec  = false;
Info=xml_read('Config\GlobalConfig.xml',Pref);
DataProviders = {Info.DataProvider};
Freqs = {Info.Freq};
Intervals = [Info.Interval];
FileType  = {Info.FileType};
% csv数据更新目录
flag1  = strcmpi(DataProviders,'Wind')&strcmpi(Freqs,'EDB')&strcmpi(FileType,'csv');
csvDir = Info(flag1).Update.DataSource;
SDate=F_ReadXMLdate(Info(flag1).Update.SDate);
EDate=F_ReadXMLdate(Info(flag1).Update.EDate);

% mat数据更新目录
flag2 = strcmpi(DataProviders,'Wind')&strcmpi(Freqs,'EDB')&strcmpi(FileType,'mat');
matDir = Info(flag2).Update.DataSource;

LogPath = Info(flag1).Update.LogPath;
if ~exist(LogPath,'dir')
    mkdir(LogPath)
end
% -------------------------------------------
fid=fopen(fullfile(LogPath,[datestr(today,'yyyymmdd'),'_WindEDB','.txt']),'wt+');%当有日志文件存在时进行覆盖（今日已经更新过）
TitleStr= ['日期时间：',datestr(now),'    Wind数据更新日志by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

s         = WindPackage.EDBData;
if byDay
    for Date = SDate:EDate
        [Flag,Pos] = ismember(Date,TradeDay);
        if ~Flag
            TitleStr= '现在是假期，电脑要休息啦！';
            disp(TitleStr)
            fprintf(fid,'%s\n',TitleStr);
            continue
        end
        ThisSDate = Date;%从前一个交易日下午15:00:01开始
        ThisEDate = Date;
        s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',csvDir);
        
        disp(datestr(Date))
        TitleStr= ['现在更新：',datestr(ThisSDate),' 至 ',datestr(ThisEDate),' 的高频数据'];
        fprintf(fid,'%s\n',TitleStr);
        
        fid=s.RunFullUpdatePlus(fid,'Overwrite',false);
        %将csv转成.mat
        disp('现在将CSV转换成MAT')
        TitleStr= ['现在更新：',datestr(ThisSDate),' 至 ',datestr(ThisEDate),' 的MAT'];
        fprintf(fid,'%s\n',TitleStr);
        WorkScripts.TranslateDomesticCSVtoMAT(Date,Date,'TargetFolder',matDir,'DataSource',csvDir);
        disp('转换完成！')
    end
else
    ThisSDate = SDate;
    ThisEDate = EDate;
    s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',csvDir);
    TitleStr= ['现在更新：',datestr(ThisSDate),' 至 ',datestr(ThisEDate),' 的高频数据'];
    fprintf(fid,'%s\n',TitleStr);
    
    fid=s.RunFullUpdatePlus(fid,'Overwrite',false);
    %将csv转成.mat
    disp('现在将CSV转换成MAT')
    TitleStr= ['现在更新：',datestr(ThisSDate),' 至 ',datestr(ThisEDate),' 的MAT'];
    fprintf(fid,'%s\n',TitleStr);
    WorkScripts.TranslateDomesticCSVtoMAT(ThisSDate,ThisEDate,'TargetFolder',matDir,'DataSource',csvDir,'InputType','Daily','OutputType','Daily');
    disp('转换完成！')
end

disp('数据下载完成！')
TitleStr= ['数据下载完成时间：',datestr(now),'    Wind数据更新日志by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

fclose('all');

end
%{
 发送邮件
subject = [datestr(now,31),'国内Daily Bar数据已下载完毕'];
content = '本日国内Daily Bar数据已下载完毕，请查看';
mail2me(subject,content)
%}

function date=F_ReadXMLdate(xmlStr)
if any(regexpi(xmlStr,'today'))
    date = eval(xmlStr);
else
    date = datenum(xmlStr);
end
end