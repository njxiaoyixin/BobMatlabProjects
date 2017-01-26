function ReadProduct_Divided (obj,InputType,OutputType, InputFileType, OutputFileType,varargin)
% InputType: Tick,Bar,Daily
% OutputType: Tick,Bar,Daily
% InputFileType: mat,csv,ts
% OutputFileType: mat,csv

%����Ĭ�ϲ���
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���

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
addParameter(p,'AdjustedExchange',obj.Exchange,@ischar);              % δ����
addParameter(p,'Overwrite',true,@(x)islogical(x)||isnumeric(x));
addParameter(p,'SearchMode','Ticker',@(x)any(validatestring(upper(x),upper(valid_searchMode))));
addParameter(p,'TranslateMode','Trans',@(x)any(validatestring(upper(x),upper(valid_translateMode))));
addParameter(p,'byWeek',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byMonth',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byYear',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'byDay',false,@(x)islogical(x)||isnumerical(x));
addParameter(p,'isIntraday',false,@(x)islogical(x)||isnumeric(x));

% ����������
parse(p,InputType,OutputType, InputFileType, OutputFileType,varargin{:});
%���ݿ��ظ��´���
if p.Results.RefreshTicker
    obj.UpdateTickerSet
end

% ���ȶ�ȡTick�ļ�����ɷ��ӵ��ļ����ٽ����ǽ���һ��

% �����ݿ����ȡ-------- under development --------------
% ��������TimeSlots
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
            % ��ȡĿ��������Ŀ¼�����ж�Ŀ¼�Ƿ����
            [~,targetSubDir] = obj.F_TargetFolderExist(Date,obj.Exchange,obj.TargetFolder);
            for i=1:numel(obj.TickerSet)
                OutFileName =[targetSubDir,'/', obj.F_SetFileName(obj.TickerSet{i},Date,obj.Exchange,OutputFileType)];
                if ~p.Results.Overwrite
                    %   ���Ŀ���ļ��Ѿ����ڣ������ǣ�ֱ������
                    if exist(OutFileName,'file')
                        continue
                    end
                end
                % ��ȡԴ�ļ����ļ���
                ThisFile=fullfile(SourceSubDir,obj.F_SetFileName(obj.TickerSet{i},Date,obj.Exchange,InputFileType));
                obj.FileTranslation(ThisFile,OutFileName,InputType,OutputType,InputFileType,OutputFileType,p.Results.Interval,p.Results.TranslateMode,varargin{:});
            end
        case 'FOLDER'
            % ֱ�ӱ���DataSource��Ӧĳ������������ļ��У���ÿһ���������ļ��Լ�Dir�����б���
            [ mResFiles, ~ ] = DeepTravel( DateDir, [], 0 )  ;
            for i=1:numel(mResFiles)
                ThisFile    = mResFiles{i};
                thisExtName = regexp(ThisFile,'\.','split');
                thisExtName = thisExtName{end};
                if ~any(strcmpi(InputFileType,thisExtName))
                    %��������ļ�����
                    continue
                end
                % ���ļ����е��ϲ�Ŀ¼��DataSource�滻ΪTargetFolder(������߲�ͬ)
                if ~strcmpi(obj.DataSource,obj.TargetFolder)
                    OutFileName = strrep(fullfile(ThisFile),fullfile(obj.DataSource),fullfile(obj.TargetFolder));
                else
                    OutFileName = ThisFile;
                end
                % ���ļ�������inputFileType�滻ΪoutputFileType(������߲�ͬ)
                if ~strcmpi(InputFileType,OutputFileType)
                    OutFileName = regexprep(OutFileName,['\.',InputFileType],['\.',lower(OutputFileType)],'preservecase');
                end
                if ~p.Results.Overwrite
                    %   ���Ŀ���ļ��Ѿ����ڣ������ǣ�ֱ������
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
