function status = FileTranslation(obj,ThisFile,OutFileName,InputType,OutputType,InputFileType,OutputFileType,Interval,TranslateMode,varargin)
% Translate File into designated type with certain Interval(if intraday bar or daily data)
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���
valid_translateMode = {'Trans','Copy'};
addOptional(p,'Interval',1,@(x) isnumeric(x) && x>0);
addOptional(p,'TranslateMode','Trans',@(x)any(validatestring(upper(x),upper(valid_translateMode))));
addParameter(p,'byWeek',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byMonth',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byYear',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byDay',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'isIntraday',false,@(x)islogical(x)||isnumeric(x));

parse(p,Interval,TranslateMode,varargin{:});

Interval = p.Results.Interval;
TranslateMode = p.Results.TranslateMode;
byWeek        = p.Results.byWeek;
byMonth       = p.Results.byMonth;
byYear        = p.Results.byYear;
byDay      = p.Results.byDay;

thisExtName = regexp(ThisFile,'\.','split');
thisExtName = thisExtName{end};
if ~any(strcmpi(InputFileType,thisExtName))
    %��������ļ�����
    return
end

if ~exist(ThisFile,'file')
    disp([ThisFile,' Doesn''''t EXIST!']);
    status = 0;
    return
end

% if strcmpi(InputType,OutputType) && strcmpi(InputFileType,OutputFileType) && strcmpi(OutFileName,ThisFile)
%     %������ļ���������ļ���ȫһ�£���������
%     status=0;
%     return
% end

% ���TargetFolder�еĵ����ڶ���Ŀ¼�����ڣ�����
% Ϊ�˷�ֹ·���ķָ����ó�'/'
index_dir1=strfind(OutFileName,'\');
index_dir2=strfind(OutFileName,'/');
if isempty(index_dir1)
    index_dir1 = 0;
end
if isempty(index_dir2)
    index_dir2 = 0;
end
targetIndexDir = max(index_dir1(end),index_dir2(end));
upperDir = OutFileName(1:targetIndexDir);
if ~exist(upperDir,'dir')
    mkdir(upperDir)
end

% ������˸��ƿ��أ���ֱ�Ӹ���
if strcmpi(TranslateMode,'Copy')
    if ~strcmpi(InputType,OutputType) || ~strcmpi(InputFileType,OutputFileType)
%         status = 0;
        error('Using the COPY TranslateMode, the InputType and OutputType along with InputFileType and OutputFileType must be the same!')
    else
        copyfile(ThisFile,OutFileName)
        status =1 ;
        return
    end
end

if strcmpi(InputFileType,'mat')
    Data=load(ThisFile);
    %���load���������ݱ�������һ��Data
    if isfield(Data,'Data')
        Data=Data.Data;
    end
else
    Data = eval(['obj.F_Read_',upper(InputFileType),'(ThisFile);']);
end
%ȷ�������ݣ�CSV�ļ�����ܻ����ֻ��һ�б���������
if isempty(Data)
    status = 0;
    return
end
% ��Data��Fieldת��ΪInternalField
OriginFields   = fieldnames(Data);
InternalFields = obj.F_GetInternalField(OriginFields);
for iField = 1:numel(OriginFields)
    DataTemp.(InternalFields{iField}) = Data.(OriginFields{iField});
end
Data = DataTemp;

% Translate Data
if strcmpi(OutputType,'Bar')   % ����tick��bar���ݣ�������bar����ת��
    %��Data���ɷ���
    Data2    = obj.F_LoadBar(Data,'Interval',Interval,'isIntraday',1);
elseif strcmpi(OutputType,'Daily') && ~strcmpi(OutputType,InputType)    % ����tick��bar���ݣ��������������
    Data2    = obj.F_LoadBar(Data,'Interval',Interval,'isIntraday',0);  
elseif strcmpi(OutputType,'Daily') && strcmpi(InputType,'Daily') && (byWeek||byYear||byMonth || byDay)  %�������������ݣ�������Ƶ�ʽ���ת��
    Data2    = obj.F_LoadBar(Data,'Interval',Interval,varargin{:});
else
    Data2 = Data;
end
if isempty(Data2)
    disp([ThisFile,' Empty!']);
    status = 0;
    return
end
Fields2  = fieldnames(Data2);
if ~isempty(Fields2)
    if ~isempty(Data2.(Fields2{1}))

        if strcmpi(OutputFileType,'mat')
            save(OutFileName,'-struct','Data2');
        else
            eval(['obj.F_Write_',upper(OutputFileType),'(OutFileName,Data2,2);']);
        end
    end
end
status = 1;
end