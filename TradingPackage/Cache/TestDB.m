% addpath(genpath('E:\CGTrader\CTPʵ�̲���1'));
addpath('E:\CGTrader\AutoTrade');
clear
clear persistent
clear global
clear timer
%%
DB = DBTrader;
%%
DB.AddTradeObj('CTP','���ڼ���');
DB.AddTradeObj('IB','IBģ��1');
DB.AddTradeObj('Wind','���12');
%%
LoginParam1.FuturesBroker = '���ڼ���';
LoginParam1.Username      = '047328';
LoginParam1.Password     = '2277565';
DB.PresetLoginParam(1,LoginParam1);
% LoginParam2.AccountNumber = 'DU423630';
% LoginParam2.SocketNumber  = 7498;
% LoginParam2.ClientId      = randi(1e6);
% DB.PresetLoginParam(2,LoginParam2);
% DB.PresetLoginParam(2);
DB.LoginTradeObj;
%%
sourceTradeObjId = 1;
targetTradeObjId = 2;
DB.DuplicateMD(sourceTradeObjId,targetTradeObjId);
%%
s=SARMRStrategy(DB.GlobalParam.Dir,DB);
%%
s.InitializeStrategy
%%
s.GetMarketData