function OutFileIndex=ReadProduct_Concat (obj,InputType,OutputType,InputFileType,OutputFileType,varargin)
%����Ĭ�ϲ���
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���

valid_dataType      = {'tick','bar','daily','EDB'};
valid_fileType      = {'ts','csv','mat'};
addRequired(p,'InputType',@(x)any(validatestring(upper(x),upper(valid_dataType))));    %����ȥ��
addRequired(p,'OutputType',@(x)any(validatestring(upper(x),upper(valid_dataType))));   %����ȥ��
addRequired(p,'inputFileType',@(x)any(validatestring(upper(x),upper(valid_fileType))));
addRequired(p,'outputFileType',@(x)any(validatestring(upper(x),upper(valid_fileType))));
addParameter(p,'RefreshTicker',true,@(x)islogical(x));
addParameter(p,'AdjustedExchange',obj.Exchange,@ischar);            %δ����
addParameter(p,'Overwrite',true,@(x)islogical(x)||isnumeric(x));
addParameter(p,'ConcatTargetFolder', [obj.TargetFolder,'/', strtrim(obj.Product)],@(x)ischar(x));  %
addParameter(p,'FileIndex', []);  % ���е�Դ�����ļ��б�
% ����������
parse(p,InputType,OutputType, InputFileType, OutputFileType,varargin{:});
%���ݿ��ظ��´���
if p.Results.RefreshTicker
    obj.UpdateTickerSet
end

if isempty(p.Results.FileIndex)
    % ��ȡ���е��ļ��б�
    FileIndex = F_IndexAll(obj,TargetFolder);
else
    FileIndex = p.Results.FileIndex;
end

OutFileIndex = struct();
iFile        = 1;
disp('Now concatenating Data...')
for i=1:numel(obj.TickerSet)
    disp(['Concatenating ',obj.TickerSet{i},' ...'])
    SubDir2 = fullfile(p.Results.ConcatTargetFolder,obj.Product);
    if ~exist(SubDir2,'dir')
        mkdir(SubDir2)
    end
    fullTargetFilename = fullfile(SubDir2,obj.F_SetFileName(obj.TickerSet{i},[],obj.Exchange,OutputFileType));
    if ~p.Results.Overwrite && exist(fullTargetFilename,'file') %������ܸ������ļ��Ѿ�����
        disp([obj.TickerSet{i},' already exist!'])
        OutFileIndex(iFile).FullFilename = fullTargetFilename;
        iFile = iFile+1;
        continue
    end
    Filename = obj.F_SetFileName(obj.TickerSet{i},[],obj.Exchange,InputFileType);
    FileFlag = find(strcmpi(Filename,{FileIndex.Filename}'));
    if isempty(FileFlag)
        disp([obj.TickerSet{i},' not exist!'])
        continue
    end
    thisFileIndex = FileIndex(FileFlag);
    DataOut = obj.F_ConcatFiles(thisFileIndex,InputFileType);
    if ~isempty(DataOut)
        disp(['Saving ',fullTargetFilename,' ...'])
        OutFileIndex(iFile).FullFilename = fullTargetFilename;
        iFile = iFile+1;
        eval(['obj.F_Write_',upper(OutputFileType),'(fullTargetFilename,DataOut,2);']);
    end
end
disp('Done.')
end