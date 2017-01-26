function funOnOrder(obj,varargin)
% disp([varargin]);

orderId=varargin{3};% 报单编号3
%遍历obj.Order寻找orderId
% currentOrderId = arrayfun(@(x) obj.Order(x).orderId,1:numel(obj.Order));
if ~isempty(obj.Order)
    currentOrderId = [obj.Order.orderId];
    iOrder = find(currentOrderId == orderId,1);
else
    iOrder = [];
end
if isempty(iOrder)
    iOrder = numel(obj.Order)+1;
%     obj.Order(iOrder,1).orderId = orderId;
end
obj.Order(iOrder,1).orderId    = orderId;
obj.Order(iOrder,1).localSymbol=varargin{4};% 和约编号
obj.Order(iOrder,1).isBuy=varargin{5}>0;% 是否为买,非0为买,否则为卖;
obj.Order(iOrder,1).isOpen=varargin{6}>0;% 是否开仓,非0为开仓,否则为平仓
obj.Order(iOrder,1).volume=varargin{7};% 委托数量
obj.Order(iOrder,1).price=varargin{8};% 委托价格
obj.Order(iOrder,1).tradedVolume=varargin{9};%已成交数量
obj.Order(iOrder,1).avgTradePrice=varargin{10};% 成交均价
obj.Order(iOrder,1).orderStatus=varargin{11};% 报单当前状态(数字)
obj.Order(iOrder,1).orderSysId=varargin{12};% 交易所报单号
obj.Order(iOrder,1).insertTime=varargin{13};% 委托时间 有问题
obj.Order(iOrder,1).statusMsg=varargin{14};% 状态信息，如果该报单失败，则为失败原因。
%自主添加
obj.Order(iOrder,1).updateTime = datestr(now,31);
obj.TimeLog.Order = datestr(now,31); 

CallbackOnOrderChange(obj,iOrder,varargin)