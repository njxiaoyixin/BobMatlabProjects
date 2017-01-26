
function B1 = FilterStruct(Data,idx,RetainedFields)
%Data must be input as a struct    
    Fields = fieldnames(Data);
    RetainedFieldCells = regexp(RetainedFields,',','split');
    B1 = struct;
    for i=1:numel(Fields)
        if any(strcmpi(Fields{i},RetainedFieldCells))
            B1.(Fields{i})  = Data.(Fields{i});
        else
            B1.(Fields{i})  = Data.(Fields{i})(idx);
        end
    end
end