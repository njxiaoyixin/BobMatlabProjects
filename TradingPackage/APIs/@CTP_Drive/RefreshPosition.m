function RefreshPosition(obj)
if isempty(obj.Position)
    return
end
for i=1:numel(obj.Position)
    try
        if obj.Position(i).isLong > 0
            Pos=GetLongPos(obj.LoginId,obj.Position(i).localSymbol);%����ĳ����Լ�Ķ�ͷ����֣���λ��
        else
            Pos=GetShortPos(obj.LoginId,obj.Position(i).localSymbol);%����ĳ����Լ�Ŀ�ͷ�����֣���λ��
        end
        obj.Position(i).volume = Pos;
    catch Err
        disp(Err.message)
    end
end
end