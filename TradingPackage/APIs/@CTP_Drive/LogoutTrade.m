function Status = LogoutTrade(obj)
try
    obj.LoginId.unregisterallevents;
    obj.LoginId.delete;
catch Err
    disp(Err.message)
end
if nargout>=1
    Status = 1;
end
%             clear;pack;clc;
disp([datestr(now,'HH:MM:SS'),'---CTPÍË³öµÇÂ½³É¹¦.---'])
end