 %% Register CTP
 CTP_Drive.RegisterCTP
 %%
clear;
clear global;
clear persistent
s= CTP_Drive;
 %% Login CTP
 s.LoginTrade;
 s.InitializeDrive
 %登录过后应停顿20秒，以实现完全登录
 %% 一键全平
 s.AllClear ;
%% 
Contract1.localSymbol = 'AU1612';
Contract2.localSymbol = 'CU1608';
Contract3.localSymbol = 'AG1612';
Contract4.localSymbol = 'JD1609';
Contract5.localSymbol = 'IF1609';
s.AddContract(Contract1);
s.AddContract(Contract2);
s.AddContract(Contract3);
s.AddContract(Contract4);
s.AddContract(Contract5);
 %%
s.GetMarketData;
%  s.GetMarketData(1);
 %% 
 % Order后面可跟的参数action,totalQuantity,orderType,lmtPrice,orderParam(包含轮询时间PollTime,轮询次数PollNum)
 % orderType可选：空白为限价，'FOK','FAK','BOC','IBOC','BOP','MTL'
 Order1.action = 'buy';
 Order1.totalQuantity = 1;
 Order1.orderStrategy   = 'LMT'; 
 Order1.lmtPrice    = 400;  %表示市价
%  Order1.lmtPrice    = 0;
 ContractId = 4;
 StrategyParam.CancelAtEnd = false;
 StrategyParam.PriceShift  = -2;
draftId =  s.AddOrder(ContractId,Order1,StrategyParam);
 %%
 s.TransmitOrder( draftId);
 %%
 s.Clear('JD1609')
%% 
s.RefreshPosition
 
 %%
 s.RefreshPosition; %刷新持仓
 %% 
orderId = s.OrderDraft(draftId).orderId;
isOrderOpen = IsOrderOpen( s.LoginId,orderId);
[LongPos,LongPositionPrice]=GetLongPos(s.LoginId,'ag1506');%返回某个合约的多头（买持）仓位。
[ShortPos,ShortPositionPrice]=GetLongPos(s.LoginId,'ag1506');%返回某个合约的空头（卖持）仓位。
LongClosable=GetLongClosable(s.LoginId,'ag1506');%返回某个合约的多头（买持）可平仓位。
ShortClosable=GetShortClosable(s.LoginId,'ag1506');%返回某个合约的空头（卖持）可平仓位。
 %% 取消订单
 %取消指定OrderId的订单
 s.CancelOrder(s.OrderDraft(draftId).orderId);
 s.CancelOrder(2);
 % 取消所有订单
 s.CancelAllOrder
 %% 撤掉所有的Open Order并停止交易，不退出CTP登录
 s.PauseTrade
 %% 重新打开交易
 s.ResumeTrade
 %% 退出CTP登录，不撤掉OpenOrder
 s.LogoutTrade
 %% 退出
 s.StopSystem