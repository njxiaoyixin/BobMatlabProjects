function [ writeType,readType,InternalField ]= F_GetFieldType(obj,field,varargin)
% 添加一个功能，将所有的类似的Field归集为一个，比如将Open_Int和OpenInt，以及openInt都归集为OpenInt
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

addParameter(p,'AllowCustomFields',false,@(x)islogical(x)||isnumeric(x))
parse(p,varargin{:})
AllowCustomFields = p.Results.AllowCustomFields;

FieldTable = {'Time','Type','Price','Volume','OpenInt','Open_Int','SP1','SV1','BP1','BV1','IsBuy','Open','High','Low','Close','Value','NumTick','Amount','PreClose','OIChg','VWAP','PctChgSettlement','Chg'};
WriteFieldType  = {'s','s','9.4f','12.0f','12.0f','12.0f','9.4f','8.0f','9.4f','8.0f','1.0f','9.4f','9.4f','9.4f','f','14.0f','10.0f','14.0f','9.4f','12.0f','9.4f','3.4f','9.4f'};
% ReadFieldType  = {'s','s','f','u','u','u','f','u','f','u','d','f','f','f','f','u','u','u','f','u','f','f','f'};
ReadFieldType  = {'s','s','f','f','f','f','f','f','f','f','f','f','f','f','f','f','f','f','f','f','f','f','f'};

if ischar(field)
    thisField = F_GetInternalField(obj,field,varargin{:});
    idx = strcmpi(FieldTable,thisField);
    if any(idx)
        writeType = WriteFieldType{idx};
        readType  = ReadFieldType{idx};
        InternalField = thisField;
        return
    elseif AllowCustomFields
        % 默认为f
        writeType = 'f';
        readType  = 'f';
        InternalField = thisField;
    else
        error(['Invalid Field: ',field])
    end
end

if iscell(field)
    writeType = cell(size(field));
    readType = cell(size(field));
    InternalField = cell(size(field));
    for i=1:numel(field)
        [ writeType{i},readType{i},InternalField{i} ] = obj.F_GetFieldType(field{i},varargin{:});
    end
end
end

