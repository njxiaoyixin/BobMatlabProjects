function status = FileTranslation(obj,ThisFile,OutFileName,InputType,OutputType,InputFileType,OutputFileType,Interval,TranslateMode,varargin)
% Translate File into designated type with certain Interval(if intraday bar or daily data)
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数
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
    %非允许的文件类型
    return
end

if ~exist(ThisFile,'file')
    disp([ThisFile,' Doesn''''t EXIST!']);
    status = 0;
    return
end

% if strcmpi(InputType,OutputType) && strcmpi(InputFileType,OutputFileType) && strcmpi(OutFileName,ThisFile)
%     %进入的文件和输出的文件完全一致，不做操作
%     status=0;
%     return
% end

% 如果TargetFolder中的倒数第二层目录不存在，则建立
% 为了防止路径的分隔符用成'/'
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

% 如果打开了复制开关，就直接复制
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
    %如果load出来的数据本来就是一个Data
    if isfield(Data,'Data')
        Data=Data.Data;
    end
else
    Data = eval(['obj.F_Read_',upper(InputFileType),'(ThisFile);']);
end
%确保有数据（CSV文件里可能会出现只有一行标题的情况）
if isempty(Data)
    status = 0;
    return
end
% 将Data的Field转换为InternalField
OriginFields   = fieldnames(Data);
InternalFields = obj.F_GetInternalField(OriginFields);
for iField = 1:numel(OriginFields)
    DataTemp.(InternalFields{iField}) = Data.(OriginFields{iField});
end
Data = DataTemp;

% Translate Data
if strcmpi(OutputType,'Bar')   % 输入tick或bar数据，对日内bar进行转换
    %将Data滚成分钟
    Data2    = obj.F_LoadBar(Data,'Interval',Interval,'isIntraday',1);
elseif strcmpi(OutputType,'Daily') && ~strcmpi(OutputType,InputType)    % 输入tick或bar数据，输出日期型数据
    Data2    = obj.F_LoadBar(Data,'Interval',Interval,'isIntraday',0);  
elseif strcmpi(OutputType,'Daily') && strcmpi(InputType,'Daily') && (byWeek||byYear||byMonth || byDay)  %输入日期型数据，对数据频率进行转换
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