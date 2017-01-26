function [orderId,ibOrder] = BaseTransmit(obj,OrderInfo,varargin)
%返回的orderId：
% 0  ： 交易数量为0
% >0 :  订单已发出
% <0 :  订单发出错误

if OrderInfo.quantity<=0
    orderId = 0;
    return
end
orderId         = obj.LoginId.orderid;
if isempty(orderId)
    ibOrder = [];
    orderId = -1;
    return
end
ibOrder         = obj.LoginId.Handle.createOrder;
ibOrder.account = obj.account;
switch upper(OrderInfo.action)
    case {'BUY','COVER'}
        ibOrder.action = 'buy';
    case {'SELL','SHORT'}
        ibOrder.action = 'sell';
end
ibOrder.action        = OrderInfo.action;
ibOrder.totalQuantity = OrderInfo.quantity;
ibOrder.lmtPrice      = OrderInfo.price;
ibOrder.orderType     = OrderInfo.orderType;

eventNames = {'openOrderEnd','openOrderEx','orderStatus'};
evtListeners = obj.LoginId.Handle.eventlisteners;
for i = 1:length(eventNames)
    k = strcmp(evtListeners(:,1),eventNames{i});
    if ~any(k) || isempty(k)
        obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnOrder(varargin{:})});
    end
end

obj.LoginId.Handle.placeOrderEx(orderId,OrderInfo.Contract.other.ibContract,ibOrder);

% obj.LoginId.createOrder(OrderInfo.Contract.other.ibContract,ibOrder,orderId,@(varargin) obj.funOnOrder(varargin{:}));


end