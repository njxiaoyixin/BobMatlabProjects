function LoginTrade(obj,LoginParam)
if obj.ConnStatus
    %Already Login
    return
end

%从配置文件中读取账户默认值
I=INI();
File = 'DefaultAccounts.ini';
I.read(File);
obj.ip       = I.(I.Global.IB).ip;
obj.account  = I.(I.Global.IB).account;
obj.port     = I.(I.Global.IB).port;
obj.clientId = randi(1e6);

if nargin >=2
    if isfield(LoginParam,'ip')
        obj.ip = LoginParam.ip;
    end
    if isfield(LoginParam,'account')
        obj.account = LoginParam.account;
    end
    if isfield(LoginParam,'port')
        obj.port = LoginParam.port;
    end
    if isfield(LoginParam,'clientId')
        obj.clientId = LoginParam.clientId;
    end
end
obj.LoginId = ibtws(obj.ip,obj.port,obj.clientId);
obj.ConnStatus = 'OK';

disp([datestr(now,'HH:MM:SS'),'--- IB---登录成功---']);
end
