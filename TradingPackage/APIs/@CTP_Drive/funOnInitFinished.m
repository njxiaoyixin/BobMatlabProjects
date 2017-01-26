function funOnInitFinished(obj,varargin)
disp([datestr(now,'HH:MM:SS'),'---CTP初始化成功！---']);
% 相关初始化工作完成，在这个事件通知之后，可以通过GetInstruments方法获得所有合约列表。
obj.SystemSwitch.InitFinished=1;
end

