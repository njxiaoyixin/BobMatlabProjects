function StopSystem(obj)
if strcmpi(obj.ConnStatus,'OK')
    close(obj.LoginId)
end
disp([datestr(now,'HH:MM:SS'),'---WIND System Shut Down.---'])
end