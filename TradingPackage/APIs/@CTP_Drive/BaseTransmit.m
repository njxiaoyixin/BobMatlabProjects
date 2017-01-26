function orderId = BaseTransmit(obj,OrderInfo,varargin)
%返回的orderId：
% 0  ： 交易数量为0
% >0 :  订单已发出
% <0 :  订单发出错误
%OrderInfo必备要素: localSymbol,action,price,quantity
if  ~isfield(OrderInfo,'quantity') || ~isfield(OrderInfo,'Contract') ...
        || ~isfield(OrderInfo,'action') || OrderInfo.quantity<=0
    % 订单要素有误或交易数量为0
    orderId = 0;
    return
end
%当仓位足够进行平仓时，优先平仓，当仓位不足以平现阶段的仓位时，开新仓
if any(strcmpi(OrderInfo.action,{'BUY','COVER'}))
    thisShortClosable = GetShortClosable(obj.LoginId,OrderInfo.Contract.localSymbol);
    if OrderInfo.quantity <= thisShortClosable
        thisAction = 'Cover';
    else
        thisAction = 'Buy';
    end
elseif any(strcmpi(OrderInfo.action,{'SHORT','SELL'}))
    thisLongClosable = GetLongClosable(obj.LoginId,OrderInfo.Contract.localSymbol);
    if OrderInfo.quantity <= thisLongClosable
        thisAction = 'Sell';
    else
        thisAction = 'Short';
    end
end
orderId = eval([thisAction,'(obj.LoginId,OrderInfo.Contract.localSymbol,OrderInfo.quantity,OrderInfo.price)']);

if isempty(orderId)
    orderId = -1;
end
end