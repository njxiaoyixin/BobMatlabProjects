function PauseTrade(obj)
obj.CancelAllOrder;
obj.SystemSwitch.isTrade = 0;
disp('Trading Switch OFF!');
end