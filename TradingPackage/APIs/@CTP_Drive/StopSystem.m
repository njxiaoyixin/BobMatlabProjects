function StopSystem(obj)
if strcmpi(obj.ConnStatus,'OK')
    obj.CancelAllOrder;
    obj.LogoutTrade;
    %             clear;pack;clc;
end
disp([datestr(now,'HH:MM:SS'),'---CTP System Shut Down.---'])

end