function StopSystem(obj)
if strcmpi(obj.ConnStatus,'OK')
    obj.CancelAllOrder;
    obj.LogoutTrade;
    obj.LoginId = [];
end
disp([datestr(now,'HH:MM:SS'),'---IB System Shut Down.---'])
end