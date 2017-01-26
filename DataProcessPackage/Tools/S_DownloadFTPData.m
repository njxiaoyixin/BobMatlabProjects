%Connect to BBG Server
function S_DownloadFTPData(varargin)
run PathSetting_DataProcess

p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���

valid_dataProvider  = {'CQG','Wind','Bloomberg'};
valid_dataType      = {'tick','bar','daily','EDB'};
valid_fileType      = {'ts','csv','mat'};
addParameter(p,'DataProvider','Wind',@(x)any(validatestring(upper(x),upper(valid_dataProvider))));    %����ȥ��
addParameter(p,'InputType','Tick',@(x)any(validatestring(upper(x),upper(valid_dataType))));    %����ȥ��
addParameter(p,'OutputType','Tick',@(x)any(validatestring(upper(x),upper(valid_dataType))));   %����ȥ��
addParameter(p,'InputFileType','csv',@(x)any(validatestring(upper(x),upper(valid_fileType))));
addParameter(p,'OutputFileType','mat',@(x)any(validatestring(upper(x),upper(valid_fileType))));
addParameter(p,'TransformData',true,@(x)islogical(x)||isnumerical(x));
parse(p,varargin{:})

% �ֶ�����
DataProvider = p.Results.DataProvider ;
InputType    = p.Results.InputType;
OutputType   = p.Results.OutputType;
InputFileType = p.Results.InputFileType;
OutputFileType = p.Results.OutputFileType;
transformData = p.Results.TransformData;
%  -----------��XML��ȡ���ò���--------------
Pref.ReadSpec  = false;
Pref.Str2Num   = 'never';
Info=xml_read('Config\GlobalConfig.xml',Pref);
DataProviders = {Info.DataProvider};
Freqs = {Info.Freq};
Intervals = {Info.Interval};
FileType  = {Info.FileType};
% csv���ݸ���Ŀ¼
flag1  = strcmpi(DataProviders,DataProvider)&strcmpi(Freqs,InputType)&strcmpi(FileType,InputFileType);
csvDir = Info(flag1).Download.TargetFolder;
SDate=F_ReadXMLdate(Info(flag1).Download.SDate);
EDate=F_ReadXMLdate(Info(flag1).Download.EDate);
% mat���ݸ���Ŀ¼
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

fid=fopen(fullfile(LogPath,[datestr(today,'yyyymmdd'),'_DownloadWindTick.txt']),'wt+');%������־�ļ�����ʱ���и��ǣ������Ѿ����¹���
TitleStr= ['����ʱ�䣺',datestr(now),'    WindTick FTP������־  by Yixin Xiao  '];
fprintf(fid,'%s\n',TitleStr);

fprintf(fid,'%s\n','Connecting to FTP Server...');
try
    FTP_Client = ftp(IP,Username,Password);
catch Err
    fprintf(fid,'%s\n',Err.message);
    fclose('all');
    return
end
TitleStr= 'FTP���ӳɹ���';
fprintf(fid,'%s\n',TitleStr);

if ~exist(csvDir,'dir')
    mkdir(csvDir);
end

load GlobalTradeDay.mat
TradeDay = GlobalTradeDay.SH;

for Date = SDate:EDate
    TitleStr= ['��ʼ��������',datestr(Date),'������'];
    fprintf(fid,'%s\n',TitleStr);
    disp(datestr(Date))
    [Flag,Pos] = ismember(Date,TradeDay);
    if ~Flag
        TitleStr= '  �����Ǽ��ڣ�����Ҫ��Ϣ����';
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
            TitleStr= '  �ļ�����!�ж��Ƿ��б����ļ�';
            fprintf(fid,'%s\n',TitleStr);
            %��������ļ����ڣ���ɾ�������ļ������и���
            LocalDir=[csvDir,'/',YearStr,'/',DateStr];
            if exist(LocalDir,'dir')
                TitleStr= '  �����ļ����ڣ�ɾ�������ļ�...';
                fprintf(fid,'%s\n',TitleStr);
                [SUCCESS,MESSAGE,MESSAGEID] = rmdir(LocalDir,'s');
                TitleStr= '  �����ļ�ɾ�����!��ʼ����...';
                fprintf(fid,'%s\n',TitleStr);
                %             continue  %��������ļ����ڣ�������
            end
            %��ʼ����
            TitleStr= '  ��ʼ����...';
            fprintf(fid,'%s\n',TitleStr);
            try
                mget(FTP_Client,[YearStr,'/',w(i).name],csvDir);
            catch Err
                fprintf(fid,'%s\n',Err.message);
            end
            TitleStr= [DateStr,'  ������ϣ�'];
            fprintf(fid,'%s\n',TitleStr);
            Check=1;
            break
        end
    end
    if Check~=1
        TitleStr= '  ���������޸������ݣ������������أ�';
        fprintf(fid,'%s\n',TitleStr);
    else
        if transformData
        % ��CSV����ת����Mat
        TitleStr= '  ��CSV����ת����mat...';
        fprintf(fid,'%s\n',TitleStr);
        WorkScripts.TranslateDomesticCSVtoMAT(Date,Date,'TargetFolder',matDir,'DataSource',csvDir,'InputType',InputType,'OutputType',OutputType);
        end
    end
end

TitleStr= '�����������ؽ���,�ر�����!';
fprintf(fid,'%s\n',TitleStr);
close(FTP_Client)
fclose('all');

subject = [datestr(now,31),'���� ',DataProvider,' ',InputType,' ������������ϣ���鿴'];
content = [datestr(now,31),'���� ',DataProvider,' ',InputType,' ������������ϣ���鿴'];
mail2me(subject,content)
end

