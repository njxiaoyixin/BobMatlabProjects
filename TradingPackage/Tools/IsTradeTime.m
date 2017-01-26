function isTradeTime = IsTradeTime(Time,localSymbol)
if nargin < 2
    localSymbol = 'cu1609';
end
if any(strcmpi(localSymbol(1:2),{'IF','IH','IC'} ))
    Session(1).OpenTime  = 9.5/24;
    Session(1).CloseTime = 11.5/24;
    Session(2).OpenTime  = 13/24;
    Session(2).CloseTime = 15/24;
else
    Session(1).OpenTime  = 9/24;
    Session(1).CloseTime = 10.25/24;
    Session(2).OpenTime  = 10.5/24;
    Session(2).CloseTime = 11.5/24;
    Session(3).OpenTime  = 13.5/24;
    Session(3).CloseTime = 15/24;
    Session(4).OpenTime  = 21/24;
    Session(4).CloseTime = 23/24;
end
isTradeTime = 0;
for i=1:numel(Session)
    if mod(Time,1) >= Session(i).OpenTime && mod(Time,1)<=Session(i).CloseTime
        isTradeTime = 1;
        return
    end
end
end