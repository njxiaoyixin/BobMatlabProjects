function AllClear(obj,varargin)
%清空所有头寸
    if obj.SystemSwitch.isTrade>0 && ~isempty(obj.Position)
        disp([datestr(now,'HH:MM:SS'),'---启动一键账户全平...---'])
        try
            ClearTimer =cell(numel(obj.Position),1);
        for i=1:numel(obj.Position)
            if obj.Position(i).volume <= 0
                continue
            end
            % 平掉指定仓位
            ClearTimer{i} = timer(...
                'Name','ClearPosition',...
                'TimerFcn',@(src,evnt)ClearCallback(obj,obj.Position(i).localSymbol,src,evnt),...
                'Period',1,...
                'ExecutionMode','fixedRate',...
                'StartDelay',0, ...
                'TasksToExecute',1,...
                'BusyMode','Queue');
            start(ClearTimer{i})
%             obj.Clear(obj.Position(i).localSymbol)
        end
        catch Err
            disp([datestr(now,'HH:MM:SS'),' 账户全平过程出错,错误原因: ',Err.message])
        end
    end
end

function ClearCallback(obj,localSymbol,varargin)
    obj.Clear(localSymbol)
end