function funOnAllClear(obj,varargin)
%�������ͷ��
    if obj.SystemSwitch.isAllClear > 0 && obj.SystemSwitch.isTrade>0 && ~isempty(obj.Position)
        disp([datestr(now,'HH:MM:SS'),'---����һ���˻�ȫƽ...---'])
        try
        for i=1:numel(obj.Position)
            if obj.Position(i).volume <= 0
                continue
            end
            % ƽ��ָ����λ
            obj.Clear(obj.Position(i).localSymbol)
        end
        catch Err
            disp([datestr(now,'HH:MM:SS'),' �˻�ȫƽ���̳���,����ԭ��: ',Err.message])
        end
        obj.SystemSwitch.isAllClear = 0;
    end
end