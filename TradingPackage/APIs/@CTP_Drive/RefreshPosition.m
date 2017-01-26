function RefreshPosition(obj)
if isempty(obj.Position)
    return
end
for i=1:numel(obj.Position)
    try
        if obj.Position(i).isLong > 0
            Pos=GetLongPos(obj.LoginId,obj.Position(i).localSymbol);%返回某个合约的多头（买持）仓位。
        else
            Pos=GetShortPos(obj.LoginId,obj.Position(i).localSymbol);%返回某个合约的空头（卖持）仓位。
        end
        obj.Position(i).volume = Pos;
    catch Err
        disp(Err.message)
    end
end
end