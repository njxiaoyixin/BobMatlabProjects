function InitializeDrive(obj)
%在LoginTrade之后运行
RegisterAllEvents(obj)
obj.GetAccount;
obj.GetOrder;
obj.GetTrade;
obj.GetPosition;
obj.SystemSwitch.InitFinished = 1;
obj.SystemSwitch.isTrade = 1;
end