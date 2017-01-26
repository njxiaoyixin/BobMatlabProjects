function InitializeDBTrader(obj)
%默认为登陆两个CTP账号，一个收纳行情，一个进行交易，后续可重载
AddTradeObj('CTP');
AddTradeObj('CTP');
%收行情采用默认的模拟账号，做交易的账号单独设置
LoginParam1.FuturesBroker = '中信建投';
LoginParam1.Username      = '10950829';
LoginParam1.Password     = '998429';
%             LoginParam1.FuturesBroker = '上期技术';
%             LoginParam1.Username      = '047328';
%             LoginParam1.Password     = '2277565';
PresetLoginParam(obj,1,LoginParam1)
LoginParam2.FuturesBroker = '上期技术';
LoginParam2.Username      = '063098';
LoginParam2.Password     = '998429';
%             LoginParam2.FuturesBroker = '中信建投';
%             LoginParam2.Username      = '10950829';
%             LoginParam2.Password     = '998429';
PresetLoginParam(obj,2,LoginParam2)
obj.LoginTradeObj; %登陆所有交易
end