function InitializeDrive(obj)
%��LoginTrade֮������
RegisterAllEvents(obj)
obj.GetAccount;
obj.GetOrder;
obj.GetTrade;
obj.GetPosition;
obj.SystemSwitch.InitFinished = 1;
obj.SystemSwitch.isTrade = 1;
end