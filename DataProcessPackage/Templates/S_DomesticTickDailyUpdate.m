%Daily Update
function S_DomesticTickDailyUpdate(varargin)
clear
addpath(genpath(pwd))
% addpath(genpath('F:\�����ļ�\�����о�\���߷���'))

%��ȡ������
% w=windmatlab;
% [TradeDay,~,~,~,~,~]=w.tdays('1990-01-01','2017-02-01');
% TradeDay=datenum(TradeDay);
% save WindTradeDay TradeDay;
load GlobalTradeDay.mat
TradeDay = GlobalTradeDay.SH;
s        = WindPackage.TickData;

%  -----------��XML��ȡ���ò���--------------
Pref.ReadSpec  = false;
Info=xml_read('Config\GlobalConfig.xml',Pref);
DataProviders = {Info.DataProvider};
Freqs = {Info.Freq};
Intervals = [Info.Interval];
FileType  = {Info.FileType};
% csv���ݸ���Ŀ¼
flag1  = strcmpi(DataProviders,'Wind')&strcmpi(Freqs,'Tick')&strcmpi(FileType,'csv');
csvDir = Info(flag1).Update.DataSource;
SDate=F_ReadXMLdate(Info(flag1).Update.SDate);
EDate=F_ReadXMLdate(Info(flag1).Update.EDate);
% mat���ݸ���Ŀ¼
flag2 = strcmpi(DataProviders,'Wind')&strcmpi(Freqs,'Tick')&strcmpi(FileType,'mat');
matDir = Info(flag2).Update.DataSource;

LogPath = Info(flag1).Update.LogPath;
if ~exist(LogPath,'dir')
    mkdir(LogPath)
end
% -------------------------------------------
fid=fopen(fullfile(LogPath,[datestr(today,'yyyymmdd'),'_WindTick','.txt']),'wt+');%������־�ļ�����ʱ���и��ǣ������Ѿ����¹���
TitleStr= ['����ʱ�䣺',datestr(now),'    Wind���ݸ�����־by Yixin Xiao'];
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
    ThisEDate = Date+15/24;
    s.SetProperties('SDate',ThisSDate,'EDate',ThisEDate,'DataSource',csvDir);
    
    disp(datestr(Date))
    TitleStr= ['���ڸ��£�',datestr(ThisSDate),' �� ',datestr(ThisEDate),' �ĸ�Ƶ����'];
    fprintf(fid,'%s\n',TitleStr);
    
    fid=s.RunFullUpdatePlus(fid);
    %��csvת��.mat
    disp('���ڽ�CSVת����MAT')
    TitleStr= ['���ڸ��£�',datestr(ThisSDate),' �� ',datestr(ThisEDate),' ��MAT'];
    fprintf(fid,'%s\n',TitleStr);
    WorkScripts.TranslateDomesticCSVtoMAT(Date,Date,'TargetFolder',matDir,'DataSource',csvDir);
    disp('ת����ɣ�')
end

disp('����������ɣ�')
TitleStr= ['�����������ʱ�䣺',datestr(now),'    Wind���ݸ�����־by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

fclose('all');

% �����ʼ�
subject = [datestr(now,31),'����Tick�������������'];
content = '���չ���Tick������������ϣ���鿴';
mail2me(subject,content)
end

function date=F_ReadXMLdate(xmlStr)
if any(regexpi(xmlStr,'today'))
    date = eval(xmlStr);
else
    date = datenum(xmlStr);
end
end