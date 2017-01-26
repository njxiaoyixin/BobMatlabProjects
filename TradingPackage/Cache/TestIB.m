 clear
 addpath(genpath('E:\CGTrader\AutoTrade'))
 addpath(genpath(pwd))
 s= IB_Drive;
 LoginParam.port = 7498;
 s.LoginTrade(LoginParam);
%  s.SetProperties('AccountNumber','U6913562');
 s.InitializeDrive;
%%
s.GetAccount;
%%
s.GetTrade;
%%
s.GetOrder;
%% 
Contract1.symbol = 'HG';
 Contract1.expiry = '201610';
 Contract1.secType = 'FUT';
 Contract1.exchange = 'NYMEX';
 Contract1.multiplier = '25000';
 Contract1.currency   = 'USD';
 
 Contract2.symbol = 'HG';
 Contract2.expiry = '201609';
 Contract2.secType = 'FUT';
 Contract2.exchange = 'NYMEX';
 Contract2.multiplier = '25000';
 Contract2.currency   = 'USD';
 
 Contract3.symbol = 'HG';
 Contract3.expiry = '201612';
 Contract3.secType = 'FUT';
 Contract3.exchange = 'NYMEX';
 Contract3.multiplier = '25000';
 Contract3.currency   = 'USD';
 
  s.AddContract(Contract1);
 s.AddContract(Contract2);
  s.AddContract(Contract3);
 %%
 s.GetMarketData;
%  s.GetMarketData(1);
 
 %% 
 Order1.action = 'buy';
 Order1.totalQuantity = 3;
 Order1.lmtPrice =1;
 Order1.orderType = 'MKT';
 ContractId = 4;
 draftId = s.AddOrder(ContractId,Order1);
 %%
 Order2.action = 'sell';
 Order2.totalQuantity = 10;
 Order2.orderStrategy = 'BOC';
 orderParam.PriceShift = 1;
%  Order1.orderType = 'MKT';
 Order2.lmtPrice = 2.198;
 ContractId = 4;
 draftId = s.AddOrder(ContractId,Order2,orderParam);
 %%
 s.TransmitOrder(draftId);
 %%
 s.CancelOrder(s.OrderDraft(draftId).orderId);
 s.CancelAllOrder
 %%
 s.Clear('CLU6')
 %%
 s.LogoutTrade
 %%
 s.StopSystem 
%% 获取IB历史行情数据 
 ss = history(s.LoginId,s.Contract(1).other.ibContract,today-1,today,'TRADES','1 min');