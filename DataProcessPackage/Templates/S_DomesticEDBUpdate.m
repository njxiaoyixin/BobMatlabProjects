%Daily Update
function S_DomesticEDBUpdate(varargin)
addpath(genpath(pwd))

p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���
addParameter(p,'byDay',false,@(x)islogical(x)||isnumerical(x));
parse(p,varargin{:});

byDay = p.Results.byDay;

%��ȡ������
load GlobalTradeDay.mat
TradeDay = GlobalTradeDay.SH;
addpath(genpath('F:\�����ļ�\�����о�\��Ʒ�ڻ�\��Ʒ�ڻ�������\Codes\LTFactorModel'))

%  -----------��XML��ȡ���ò���--------------
Pref.ReadSpec  = false;
Info=xml_read('Config\GlobalConfig.xml',Pref);
DataProviders = {Info.DataProvider};
Freqs = {Info.Freq};
Intervals = [Info.Interval];
FileType  = {Info.FileType};
% csv���ݸ���Ŀ¼
flag1  = strcmpi(DataProviders,'Wind')&strcmpi(Freqs,'EDB')&strcmpi(FileType,'csv');
csvDir = Info(flag1).Update.DataSource;
SDate=F_ReadXMLdate(Info(flag1).Update.SDate);
EDate=F_ReadXMLdate(Info(flag1).Update.EDate);

% mat���ݸ���Ŀ¼
flag2 = strcmpi(DataProviders,'Wind')&strcmpi(Freqs,'EDB')&strcmpi(FileType,'mat');
matDir = Info(flag2).Update.DataSource;

LogPath = Info(flag1).Update.LogPath;
if ~exist(LogPath,'dir')
    mkdir(LogPath)
end
% -------------------------------------------
fid=fopen(fullfile(LogPath,[datestr(today,'yyyymmdd'),'_WindEDB','.txt']),'wt+');%������־�ļ�����ʱ���и��ǣ������Ѿ����¹���
TitleStr= ['����ʱ�䣺',datestr(now),'    Wind���ݸ�����־by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

s         = WindPackage.EDBData;
if byDay
    for Date = SDate:EDate
        [Flag,Pos] = ismember(Date,TradeDay);
        if ~Flag
            TitleStr= '�����Ǽ��ڣ�����Ҫ��Ϣ����';
            disp(TitleStr)
            fprintf(fid,'%s\n',TitleStr);
            continue
        end
        ThisSDate = Date;%��ǰһ������������15:00:01��ʼ
        ThisEDate = Date;
        s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',csvDir);
        
        disp(datestr(Date))
        TitleStr= ['���ڸ��£�',datestr(ThisSDate),' �� ',datestr(ThisEDate),' �ĸ�Ƶ����'];
        fprintf(fid,'%s\n',TitleStr);
        
        fid=s.RunFullUpdatePlus(fid,'Overwrite',false);
        %��csvת��.mat
        disp('���ڽ�CSVת����MAT')
        TitleStr= ['���ڸ��£�',datestr(ThisSDate),' �� ',datestr(ThisEDate),' ��MAT'];
        fprintf(fid,'%s\n',TitleStr);
        WorkScripts.TranslateDomesticCSVtoMAT(Date,Date,'TargetFolder',matDir,'DataSource',csvDir);
        disp('ת����ɣ�')
    end
else
    ThisSDate = SDate;
    ThisEDate = EDate;
    s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',csvDir);
    TitleStr= ['���ڸ��£�',datestr(ThisSDate),' �� ',datestr(ThisEDate),' �ĸ�Ƶ����'];
    fprintf(fid,'%s\n',TitleStr);
    
    fid=s.RunFullUpdatePlus(fid,'Overwrite',false);
    %��csvת��.mat
    disp('���ڽ�CSVת����MAT')
    TitleStr= ['���ڸ��£�',datestr(ThisSDate),' �� ',datestr(ThisEDate),' ��MAT'];
    fprintf(fid,'%s\n',TitleStr);
    WorkScripts.TranslateDomesticCSVtoMAT(ThisSDate,ThisEDate,'TargetFolder',matDir,'DataSource',csvDir,'InputType','Daily','OutputType','Daily');
    disp('ת����ɣ�')
end

disp('����������ɣ�')
TitleStr= ['�����������ʱ�䣺',datestr(now),'    Wind���ݸ�����־by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

fclose('all');

end
%{
 �����ʼ�
subject = [datestr(now,31),'����Daily Bar�������������'];
content = '���չ���Daily Bar������������ϣ���鿴';
mail2me(subject,content)
%}

function date=F_ReadXMLdate(xmlStr)
if any(regexpi(xmlStr,'today'))
    date = eval(xmlStr);
else
    date = datenum(xmlStr);
end
end