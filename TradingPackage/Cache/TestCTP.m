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
 %��¼����Ӧͣ��20�룬��ʵ����ȫ��¼
 %% һ��ȫƽ
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
 % Order����ɸ��Ĳ���action,totalQuantity,orderType,lmtPrice,orderParam(������ѯʱ��PollTime,��ѯ����PollNum)
 % orderType��ѡ���հ�Ϊ�޼ۣ�'FOK','FAK','BOC','IBOC','BOP','MTL'
 Order1.action = 'buy';
 Order1.totalQuantity = 1;
 Order1.orderStrategy   = 'LMT'; 
 Order1.lmtPrice    = 400;  %��ʾ�м�
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
 s.RefreshPosition; %ˢ�³ֲ�
 %% 
orderId = s.OrderDraft(draftId).orderId;
isOrderOpen = IsOrderOpen( s.LoginId,orderId);
[LongPos,LongPositionPrice]=GetLongPos(s.LoginId,'ag1506');%����ĳ����Լ�Ķ�ͷ����֣���λ��
[ShortPos,ShortPositionPrice]=GetLongPos(s.LoginId,'ag1506');%����ĳ����Լ�Ŀ�ͷ�����֣���λ��
LongClosable=GetLongClosable(s.LoginId,'ag1506');%����ĳ����Լ�Ķ�ͷ����֣���ƽ��λ��
ShortClosable=GetShortClosable(s.LoginId,'ag1506');%����ĳ����Լ�Ŀ�ͷ�����֣���ƽ��λ��
 %% ȡ������
 %ȡ��ָ��OrderId�Ķ���
 s.CancelOrder(s.OrderDraft(draftId).orderId);
 s.CancelOrder(2);
 % ȡ�����ж���
 s.CancelAllOrder
 %% �������е�Open Order��ֹͣ���ף����˳�CTP��¼
 s.PauseTrade
 %% ���´򿪽���
 s.ResumeTrade
 %% �˳�CTP��¼��������OpenOrder
 s.LogoutTrade
 %% �˳�
 s.StopSystem