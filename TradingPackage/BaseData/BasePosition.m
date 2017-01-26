classdef BasePosition
    properties
        contractId
        localSymbol
        updateTime
        contractDetails
        isLong = 0
        volume = 0
        positionPNL = 0
        avgPositionPrice = 0
        unrealizedPNL = 0
        unrealizedPct= 0
        avgOpenPrice = 0
        realizedPNL = 0 
        realizedPrice = 0
        totalClosable = 0
        todayClosable =0
        marketValue=0
        marketPrice=0
        currency        
        other
        %IB  Ù–‘
        % type  -updatePortfolioEx
        % Source - IBTWS object
        % EventID
        % contract(conId,symbol,secType,expiry,strike,multiplier,exchange,currency,localSymbol...)
        % Position - positive or negative
        % marketPrice
        % marketValue
        % averageCost
        % unrealizedPNL
        % realizedPNL
        % accountName
    end
    methods
        function obj2 = plus(obj,PositionInfo)
            obj2 = obj;
            if isstruct(PositionInfo)
                meta = ?BasePosition;
                thisPropertyList = {meta.PropertyList.Name};
                fields = fieldnames(PositionInfo);
                for i=1:numel(fields)
                    ind = strcmpi(fields{i},thisPropertyList);
                    if any(ind)
                        obj2.(thisPropertyList{ind}) = PositionInfo.(fields{i});
                    else
                        obj2.other.(fields{i}) = PositionInfo.(fields{i});
                    end
                end
            end
        end
    end
end