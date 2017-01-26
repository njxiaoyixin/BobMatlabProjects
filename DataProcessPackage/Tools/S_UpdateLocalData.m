%Daily Update
function S_UpdateLocalData(varargin)
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
parse(p,varargin{:})
addParameter(p,'TransformData',true,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byDay',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'Overwrite',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'isNight',false,@(x)islogical(x)||isnumerical(x));

parse(p,varargin{:});

DataProvider = p.Results.DataProvider ;
InputType    = p.Results.InputType;
OutputType   = p.Results.OutputType;
InputFileType = p.Results.InputFileType;
OutputFileType = p.Results.OutputFileType;
byDay = p.Results.byDay;
overwrite = p.Results.Overwrite;
transformData = p.Results.TransformData;
isNight = p.Results.isNight;

%��ȡ������
disp([datestr(now,31),'--Loading Config...'])
load GlobalTradeDay.mat
TradeDay = GlobalTradeDay.SH;

s  = eval([DataProvider,'Package.',InputType,'Data']);
%  -----------��XML��ȡ���ò���--------------
Pref.ReadSpec  = false;
Pref.Str2Num   = 'never';
Info=xml_read('Config\GlobalConfig.xml',Pref);
DataProviders = {Info.DataProvider};
Freqs = {Info.Freq};
Intervals = {Info.Interval};  % Ҳ���ַ���
FileType  = {Info.FileType};
% csv���ݸ���Ŀ¼
flag1  = strcmpi(DataProviders,DataProvider)&strcmpi(Freqs,InputType) &strcmpi(FileType,InputFileType);
inputDir = Info(flag1).Update.DataSource;
SDate=F_ReadXMLdate(Info(flag1).Update.SDate);
EDate=F_ReadXMLdate(Info(flag1).Update.EDate);

% mat���ݸ���Ŀ¼
flag2 = strcmpi(DataProviders,DataProvider)&strcmpi(Freqs,OutputType)&strcmpi(FileType,OutputFileType);
outputDir = Info(flag2).Update.DataSource;

LogPath = Info(flag1).Update.LogPath;
if ~exist(LogPath,'dir')
    mkdir(LogPath)
end
% -------------------------------------------
LogFile = fullfile(LogPath,[datestr(today,'yyyymmdd'),'_',DataProvider,' ',InputType,'.txt']);
disp([datestr(now,31),'--Log to file: ',LogFile])
fid=fopen(LogFile,'wt+');%������־�ļ�����ʱ���и��ǣ������Ѿ����¹���
TitleStr= [datestr(now,31),'    ',DataProvider,' ',InputType,' local data update log by Yixin Xiao  '];
disp(TitleStr)
fprintf(fid,'%s\n',TitleStr);

if byDay
    for Date = SDate:EDate
        [s,fid] = UpdateData(fid,s,InputType,TradeDay,Date,Date,inputDir,outputDir,overwrite,transformData,isNight);
    end
else
    [~,fid] = UpdateData(fid,s,InputType,TradeDay,SDate,EDate,inputDir,outputDir,overwrite,transformData,isNight);
end
TitleStr= [datestr(now,31),'  --Local Data Update Finished--  ',DataProvider,' ',InputType,' local data update log by Yixin Xiao  --'];
disp(TitleStr)
fprintf(fid,'%s\n',TitleStr);
fclose(fid);
% �����ʼ�
address = java.net.InetAddress.getLocalHost;
IPAddress = char(address.getHostAddress);
subject = [datestr(now,31),'-- ',DataProvider,' ',InputType,' local data update finished on ip: ',IPAddress ];
content = '--Local Data Update Finished. Please check on your computer.--';
mail2me(subject,content)
end

function [s,fid] = UpdateData(fid,s,InputType,TradeDay,SDate,EDate,inputDir,outputDir,overwrite,transformData,isNight)
if floor(SDate) == floor(EDate)
    if isNight
        % �賿����Ҫ�жϸ��յ�ǰһ���ǲ��ǽ�����
        [Flag,Pos] = ismember(floor(SDate-1),TradeDay);
        if ~Flag
            TitleStr= [datestr(now,31),'--',datestr(SDate,1),' is not a trading day. Proceed onto the next.'];
            disp(TitleStr)
            fprintf(fid,'%s\n',TitleStr);
            return
        else
            Pos = Pos+1;
        end
    else
        [Flag,Pos] = ismember(floor(SDate),TradeDay);
        if ~Flag
            TitleStr= [datestr(now,31),'--',datestr(SDate,1),' is not a trading day. Proceed onto the next.'];
            disp(TitleStr)
            fprintf(fid,'%s\n',TitleStr);
            return
        end
    end
else
    Pos = find(TradeDay>floor(SDate),1,'first');
end
if strcmpi(InputType,'Bar') || strcmpi(InputType,'Tick')
    SDate = TradeDay(Pos-1)+15/24+1/60/60/24;%��ǰһ������������15:00:01��ʼ
    EDate = floor(EDate)+15/24;
else
    SDate  = floor(SDate);
    EDate  = floor(EDate);
end

s.SetProperties('SDate',SDate,'EDate',EDate,'DataSource',inputDir);
TitleStr= [datestr(now,31),'--Now Updating Data from ',datestr(SDate),' to ',datestr(EDate)];
disp(TitleStr)
fprintf(fid,'%s\n',TitleStr);

fid=s.RunFullUpdatePlus(fid,'Overwrite',overwrite);
%��csvת��.mat
TitleStr = [datestr(now,31),'--Now transforming data from fileType ',...
    'csv',' to fileType ','mat',' with date range from ',...
    datestr(SDate,31),' to ',datestr(EDate,31)];
disp(TitleStr)
fprintf(fid,'%s\n',TitleStr);

if transformData
    TranslateDomesticCSVtoMAT(SDate,EDate,'TargetFolder',outputDir,'DataSource',inputDir,'InputFileType','csv','OutputFileType','mat');
    TitleStr = [datestr(now,31),'--Data transformation finished.'];
    disp(TitleStr)
    fprintf(fid,'%s\n',TitleStr);
end
end