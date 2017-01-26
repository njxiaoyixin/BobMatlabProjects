function thisField = F_GetInternalField(obj,field,varargin)
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

addParameter(p,'AllowCustomFields',false,@(x)islogical(x)||isnumeric(x))
parse(p,varargin{:})
AllowCustomFields = p.Results.AllowCustomFields;

if ischar(field)
    switch upper(field)
        case {'OPENINT','OPEN_INT','OPEN_INTEREST','OPENINTEREST'}
            thisField = 'OpenInt';
        case {'AMOUNT','VALUE'}
            thisField = 'Amount';
        case {'PRE_CLOSE','PRECLOSE'}
            thisField = 'PreClose';
        case{'SP1','ASK'}
            thisField = 'SP1';
        case{'BP1','BID'}
            thisField = 'BP1';
        case{'SV1','ASKVOLUME'}
            thisField = 'SV1';
        case{'BV1','BIDVOLUME'}
            thisField = 'BV1';
        otherwise
            thisField = [upper(field(1)),field(2:end)];
    end
    return
end
if iscell(field) && numel(field)>0
    thisField = cell(size(field));
    for i=1:numel(field)
        thisField{i} = obj.F_GetInternalField(field{i},varargin{:});
    end
else
    thisField = [];
end
end