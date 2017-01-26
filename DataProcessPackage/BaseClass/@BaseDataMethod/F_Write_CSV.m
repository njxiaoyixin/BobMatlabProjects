function Status        = F_Write_CSV(obj,FileName,Data,ReadOption,varargin)
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

addRequired(p,'FileName',@ischar)
addRequired(p,'Data',@isstruct)
addOptional(p,'ReadOption',@(x) x==1 || x==2)
addParameter(p,'AllowCustomFields',false,@(x)islogical(x)||isnumeric(x))
parse(p,FileName,Data,ReadOption,varargin{:})
AllowCustomFields = p.Results.AllowCustomFields;

%Data是一个struct,内含Price,volume等9个变量
Status = 1;
%ReadOption: 设置写入文件的参数
%             '1'打开或者创建文件，并覆盖原内容
%             '2'打开或者创建文件，并在文件后面接入新内容
if nargin<3
    %     ReadOption默认设置为1
    ReadOption=1;
end

switch ReadOption
    case 1
        SubReadOption = 'w+t';
    case 2
        SubReadOption = 'a+t';
    case 3
        SubReadOption = 'rt';
end
%打开文件
%如果不允许覆盖，则跳过直接退出
if strcmpi(SubReadOption,'rt') && exist(FileName,'file')
    return
else
    OriginFields = fieldnames(Data);
    [ Types,~,Fields ]= obj.F_GetFieldType(OriginFields,'AllowCustomFields',AllowCustomFields);
    if exist(FileName,'file') && ReadOption==2
        %如果文件已经存在，则不写入标题栏
        FID         = fopen(FileName,SubReadOption);
    else
        %如果文件不存在则根据SubReadOptiond打开文件（可能会新建文件）
        FID         = fopen(FileName,SubReadOption);
        if FID~=-1
            %如果新建了文件，则写入标题栏
            for i=1:(numel(Fields)-1)
                fprintf(FID,'%s,',Fields{i});
            end
            fprintf(FID,'%s\n',Fields{end});
        else
            %如果没有新建文件，则退出
            return
        end
    end
end

%写入数据

% FieldTable = {'Time','Price','Volume','Open_Int','SP1','SV1','BP1','BV1','isBuy','Type','Open','High','Low','Close','Value','NumTick','Amount','Pre_Close','OI_Chg'};
% FieldType  = {'s','9.4f','12.0f','12.0f','9.4f','8.0f','9.4f','8.0f','d','s','9.4f','9.4f','9.4f','f','14.0f','10.0f','14.0f','9.4f','12.0f'};

for i=1:numel(Data.Time)
    if ~iscell(Data.Time(1))
        fprintf(FID,'%s,',datestr(Data.Time(i),'yyyy-mm-dd HH:MM:SS'));
    else
        fprintf(FID,'%s,',Data.Time{i});
    end
    
    for j=1:(numel(Fields)-1)
        if ~strcmpi(Fields{j},'Time')
            fprintf(FID,['%',Types{j},','],Data.(OriginFields{j})(i));
        end
    end
    fprintf(FID,['%',Types{end},'\n'],Data.(OriginFields{end})(i));
end
fclose(FID);
end