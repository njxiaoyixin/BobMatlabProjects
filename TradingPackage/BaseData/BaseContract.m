classdef BaseContract
    properties
        insertTime
        secType
        localSymbol
        description
        symbol
        expiry
        multiplier
        minTick
        currency
        other
    end
    methods
        function out = get(obj)
            meta = ?BaseContract;
            propertyList = {meta.PropertyList.Name};
            out = struct;
            for i=1:numel(propertyList)
                out.(propertyList{i}) = obj.(propertyList{i});
            end
        end
    end
end