function AssignMarketData(obj,w_wsq_data,w_wsq_codes,w_wsq_fields,w_wsq_times)
if isempty(w_wsq_data)
    return
end
if nargin < 5
    w_wsq_times = now;
end
[InternalFields,WindFields] = obj.GenerateFields;
for i=1:numel(w_wsq_codes)
    Ind1 = strcmpi(w_wsq_codes{i},{obj.Contract.localSymbol});
    if ~any(Ind1)
        disp([obj.Contract.localSymbol,': ','No Corresponding Contract Found for Market Data!Adding New'])
        orderInfo.localSymbol = w_wsq_codes{i};
        Ind1 =  obj.AddContract(orderInfo);
    end
    for j=1:numel(w_wsq_fields)
        Ind2 = strcmpi(w_wsq_fields{j},WindFields);
        if ~any(Ind2)
            continue
        end
        try
            obj.MarketData(Ind1,1).(InternalFields{Ind2}) = w_wsq_data(i,j);
        catch
            obj.MarketData(Ind1,1).(InternalFields{Ind2}) = w_wsq_data(j,i);
        end
        switch InternalFields{Ind2}
            case 'pctChange'
                obj.MarketData(Ind1,1).(InternalFields{Ind2}) = obj.MarketData(Ind1,1).(InternalFields{Ind2})/100;
        end
        
        obj.MarketData(Ind1,1).updateTime = datestr(w_wsq_times,'yyyy-mm-dd HH:MM:SS');
    end
end
end