function AllClear(obj,varargin)
%�������ͷ��
    if obj.SystemSwitch.isTrade>0 && ~isempty(obj.Position)
        disp([datestr(now,'HH:MM:SS'),'---����һ���˻�ȫƽ...---'])
        try
            ClearTimer =cell(numel(obj.Position),1);
        for i=1:numel(obj.Position)
            if obj.Position(i).volume <= 0
                continue
            end
            % ƽ��ָ����λ
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
            disp([datestr(now,'HH:MM:SS'),' �˻�ȫƽ���̳���,����ԭ��: ',Err.message])
        end
    end
end

function ClearCallback(obj,localSymbol,varargin)
    obj.Clear(localSymbol)
end