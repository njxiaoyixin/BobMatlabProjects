function LoginTrade(obj,LoginParam)
obj.LoginId = windmatlab;
connStatus = isconnected(obj.LoginId);
if connStatus
    obj.ConnStatus = 'OK';
    disp([datestr(now,'HH:MM:SS'),'--- Wind---µÇÂ¼³É¹¦---']);
else
    obj.ConnStatus = 'NotConnected';
    disp([datestr(now,'HH:MM:SS'),'--- Wind---µÇÂ¼Ê§°Ü---']);
end
end