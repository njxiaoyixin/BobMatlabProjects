function funOnAllClear(obj,varargin)
%清空所有头寸
    if obj.SystemSwitch.isAllClear > 0 && obj.SystemSwitch.isTrade>0 && ~isempty(obj.Position)
        disp([datestr(now,'HH:MM:SS'),'---启动一键账户全平...---'])
        try
        for i=1:numel(obj.Position)
            if obj.Position(i).volume <= 0
                continue
            end
            % 平掉指定仓位
            obj.Clear(obj.Position(i).localSymbol)
        end
        catch Err
            disp([datestr(now,'HH:MM:SS'),' 账户全平过程出错,错误原因: ',Err.message])
        end
        obj.SystemSwitch.isAllClear = 0;
    end
end