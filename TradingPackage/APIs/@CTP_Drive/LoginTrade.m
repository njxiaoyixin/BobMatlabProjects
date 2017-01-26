function LoginTrade(obj,LoginParam)
if obj.ConnStatus
    %Already Login
    return
end

%从配置文件中读取账户默认值
I=INI();
File = 'DefaultAccounts.ini';
I.read(File);
obj.Broker   = I.(I.Global.CTP).FuturesBroker;
obj.Username = I.(I.Global.CTP).Username;
obj.Password = I.(I.Global.CTP).Password;
if ~(nargin < 2 || ~isfield(LoginParam,'FuturesBroker') || isempty(LoginParam.FuturesBroker))
    obj.Broker = LoginParam.FuturesBroker;
end
if ~(nargin < 2 || ~isfield(LoginParam,'Username') || isempty(LoginParam.Username))
    obj.Username = LoginParam.Username;
    obj.Password = LoginParam.Password;
end
FuturesBroker = obj.Broker;
Username = obj.Username;
Password = obj.Password;
obj.LoginId=actxserver('ctpcom.ICTPClientAPI');
UsernameStr  = num2str(Username);
UsernameStr(1:end-3) = '*';
disp([datestr(now,'HH:MM:SS'),'---',FuturesBroker,'---',UsernameStr,'---登录中...---']);
if ~ischar(Username)
    Username=num2str(Username);
end
if ~ischar(Password)
    Password=num2str(Password);
end
verify=Login(obj.LoginId,[FuturesBroker,'.xml'],Username,Password);
if  verify==0
    disp([datestr(now,'HH:MM:SS'),'---',FuturesBroker,'---',UsernameStr,'---登录成功---']);
    %                 obj.ResumeTrade;
    %初始化系统开关
    obj.SystemSwitch.InitFinished = 0;
    obj.SystemSwitch.MDDConn      = 0;
    obj.SystemSwitch.isTrade      = 1;
    obj.ConnStatus                = 'OK';
    obj.Busy                      = [];%具有localSymbol,action还有orderStrategy三个属性
else
    error([datestr(now,'HH:MM:SS'),'---',FuturesBroker,'---登录失败---']);
end
end