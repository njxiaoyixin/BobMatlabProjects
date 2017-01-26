function DataOut = F_ConcatFiles(obj,FileIndex,InputFileType)
% FileIndex有三个Field
%     FileIndex.FullFilenames   = 包含文件名的完整路径
%     FileIndex.Filenames       = 目标文件名
%     FileIndex.Dates           = 目标文件日期

DataTemp = struct;
DataOut = struct;
% 以时间的升序来连接文件
[~,DateFlag]=sort([FileIndex.Date]);
temp_fullFilenames = {FileIndex.FullFilename}';
for fileCount=1:numel(DateFlag)
    fullFilename = temp_fullFilenames{DateFlag(fileCount)};
    if strcmpi(InputFileType,'mat')
        Data=load(fullFilename);
        %如果load出来的数据本来就是一个Data
        if isfield(Data,'Data2')
            Data=Data.Data2;
        end
    else
        Data = eval(['obj.F_Read_',upper(InputFileType),'(fullFilename)']);
    end
    OriginFields   = fieldnames(Data);
    InternalFields = obj.F_GetInternalField(OriginFields);
    if numel(OriginFields)<2  % 避免数据里只有time 没有其他数据
        continue
    end
    FieldNum = 0;
    for k=1:numel(OriginFields)
        if isfield(DataTemp,InternalFields{k})
            try
                DataTemp.(InternalFields{k})=[DataTemp.(InternalFields{k});Data.(OriginFields{k})];
            catch err
                save Data
                error(err)
            end
        else
            DataTemp.(InternalFields{k})=Data.(OriginFields{k});
        end
        if FieldNum~=0
            if FieldNum ~= numel(Data.(OriginFields{k}))
                error('Field Number Not Equal!')
            end
        else
            FieldNum = numel(Data.(OriginFields{k}));
        end
    end
    %自查DataTemp里面的Time和Close,volume,value
    %是否数量相同,注：有的数据的Volume和Value可能缺失，所以不查这两个field
    %CheckFields = {'Close','Open','High','Low','Volume','Value','NumTick','OI','Open_Int'};
    CheckFields = {'Close','Open','High','Low'};
    for iField=1:numel(CheckFields)
        if isfield(DataTemp,CheckFields{iField})
            if numel(DataTemp.Time)~=numel(DataTemp.(CheckFields{iField}))
                error(['Time and ',CheckFields{iField},' are not Equal!'])
            end
        end
    end
end
%     end
%Save File
if ~isempty(InternalFields)
    if ~isempty(DataTemp.Time)
        %合并同一时间的数据
        DataOut.Time=unique(DataTemp.Time);
        for iField = 1:numel(InternalFields)
            if ~strcmpi(InternalFields{iField},'Time')
                DataOut.(InternalFields{iField})=nan(size(DataOut.Time));
            end
        end
        for k=1:numel(DataOut.Time)
            Ind=(DataTemp.Time==DataOut.Time(k));
            for iField = 1:numel(InternalFields)
                Temp=DataTemp.(InternalFields{iField})(Ind);
                switch upper(InternalFields{iField})
                    case upper('Open')
                        DataOut.(InternalFields{iField})(k) = Temp(1);
                    case upper('High')
                        DataOut.(InternalFields{iField})(k) = max(Temp);
                    case upper('Low')
                        DataOut.(InternalFields{iField})(k) = min(Temp);
                    case {upper('Volume'),upper('Value'),upper('Amount'),upper('NumTick')}
                        DataOut.(InternalFields{iField})(k) = sum(Temp);
                    otherwise
                        DataOut.(InternalFields{iField})(k) = Temp(end);
                end
            end
        end
    end
end