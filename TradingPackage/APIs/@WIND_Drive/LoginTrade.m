function LoginTrade(obj,LoginParam)
obj.LoginId = windmatlab;
connStatus = isconnected(obj.LoginId);
if connStatus
    obj.ConnStatus = 'OK';
    disp([datestr(now,'HH:MM:SS'),'--- Wind---��¼�ɹ�---']);
else
    obj.ConnStatus = 'NotConnected';
    disp([datestr(now,'HH:MM:SS'),'--- Wind---��¼ʧ��---']);
end
end