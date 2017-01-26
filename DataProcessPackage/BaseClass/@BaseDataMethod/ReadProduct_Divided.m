function ReadProduct_Divided (obj,InputType,OutputType, InputFileType, OutputFileType,varargin)
% InputType: Tick,Bar,Daily
% OutputType: Tick,Bar,Daily
% InputFileType: mat,csv,ts
% OutputFileType: mat,csv

%设置默认参数
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

valid_dataType      = {'tick','bar','daily','EDB'};
valid_fileType      = {'ts','csv','mat'};
valid_searchMode    = {'Ticker','Folder'};
valid_translateMode = {'Trans','Copy'};
addRequired(p,'InputType',@(x)any(validatestring(upper(x),upper(valid_dataType))));
addRequired(p,'OutputType',@(x)any(validatestring(upper(x),upper(valid_dataType))));
addRequired(p,'inputFileType',@(x)any(validatestring(upper(x),upper(valid_fileType))));
addRequired(p,'outputFileType',@(x)any(validatestring(upper(x),upper(valid_fileType))));
addParameter(p,'Interval',1,@(x) isnumeric(x) && x>0);
addParameter(p,'RefreshTicker',true,@(x)islogical(x));
addParameter(p,'AdjustedExchange',obj.Exchange,@ischar);              % 未启用
addParameter(p,'Overwrite',true,@(x)islogical(x)||isnumeric(x));
addParameter(p,'SearchMode','Ticker',@(x)any(validatestring(upper(x),upper(valid_searchMode))));
addParameter(p,'TranslateMode','Trans',@(x)any(validatestring(upper(x),upper(valid_translateMode))));
addParameter(p,'byWeek',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byMonth',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byYear',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byDay',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'isIntraday',false,@(x)islogical(x)||isnumeric(x));

% 检测输入变量
parse(p,InputType,OutputType, InputFileType, OutputFileType,varargin{:});
%根据开关更新代码
if p.Results.RefreshTicker
    obj.UpdateTickerSet
end

% 首先读取Tick文件，存成分钟的文件，再将他们接在一起

% 日数据跨天读取-------- under development --------------
% 首先生成TimeSlots
% [TimeZone,~,~,~,Calendar] = F_LookupExchangeTime(obj,Data.Time(i),obj.Exchange,obj.Product); 
% if ~evalin('base','exist(''TradeDay'',''var'')')
%     evalin('base','load TradeDay');
% end
% TradeDay = evalin('base','TradeDay');
% TradeDay = TradeDay.(Calendar);
% TradeDay = obj.F_ChangeTimeZone(TradeDay,TimeZone,obj.TimeZone);
% 
% TimeSeries = TradeDay(TradeDay>=obj.SDate & TradeDay<=obj.SDate);
% [OpenTimeSlots,TimeSlots]=F_GenerateTimeSlots(obj,TimeSeries,varargin);
%--------------------------------------------------------

Dates = obj.F_GenerateDates;
for Date=Dates;
    disp(['Now Processing ',datestr(Date),' ...'])
    Exchange=obj.GetProperties('Exchange');
    [~,SourceSubDir,DateDir] = obj.F_FolderExist(Date,Exchange,obj.DataSource); %
    if ~exist(DateDir,'dir')
        disp('This Date is not a Trading Day!');
        continue
    end
    
    switch upper(p.Results.SearchMode)
        case 'TICKER'
            % 获取目标存放数据目录，并判断目录是否存在
            [~,targetSubDir] = obj.F_TargetFolderExist(Date,obj.Exchange,obj.TargetFolder);
            for i=1:numel(obj.TickerSet)
                OutFileName =[targetSubDir,'/', obj.F_SetFileName(obj.TickerSet{i},Date,obj.Exchange,OutputFileType)];
                if ~p.Results.Overwrite
                    %   如果目标文件已经存在，不覆盖，直接跳过
                    if exist(OutFileName,'file')
                        continue
                    end
                end
                % 获取源文件的文件名
                ThisFile=fullfile(SourceSubDir,obj.F_SetFileName(obj.TickerSet{i},Date,obj.Exchange,InputFileType));
                obj.FileTranslation(ThisFile,OutFileName,InputType,OutputType,InputFileType,OutputFileType,p.Results.Interval,p.Results.TranslateMode,varargin{:});
            end
        case 'FOLDER'
            % 直接遍历DataSource对应某个日期下面的文件夹，将每一个单独的文件以及Dir都进行遍历
            [ mResFiles, ~ ] = DeepTravel( DateDir, [], 0 )  ;
            for i=1:numel(mResFiles)
                ThisFile    = mResFiles{i};
                thisExtName = regexp(ThisFile,'\.','split');
                thisExtName = thisExtName{end};
                if ~any(strcmpi(InputFileType,thisExtName))
                    %非允许的文件类型
                    continue
                end
                % 将文件名中的上层目录由DataSource替换为TargetFolder(如果二者不同)
                if ~strcmpi(obj.DataSource,obj.TargetFolder)
                    OutFileName = strrep(fullfile(ThisFile),fullfile(obj.DataSource),fullfile(obj.TargetFolder));
                else
                    OutFileName = ThisFile;
                end
                % 将文件类型由inputFileType替换为outputFileType(如果二者不同)
                if ~strcmpi(InputFileType,OutputFileType)
                    OutFileName = regexprep(OutFileName,['\.',InputFileType],['\.',lower(OutputFileType)],'preservecase');
                end
                if ~p.Results.Overwrite
                    %   如果目标文件已经存在，不覆盖，直接跳过
                    if exist(OutFileName,'file')
                        continue
                    end
                end
                obj.FileTranslation(ThisFile,OutFileName,InputType,OutputType,InputFileType,OutputFileType,p.Results.Interval,p.Results.TranslateMode,varargin{:});
            end
    end
end
disp([datestr(now,31),' -- ReadProduct_Divided -- Done --'])
end
