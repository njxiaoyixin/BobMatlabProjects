function orderId = BaseTransmit(obj,OrderInfo,varargin)
%���ص�orderId��
% 0  �� ��������Ϊ0
% >0 :  �����ѷ���
% <0 :  ������������
%OrderInfo�ر�Ҫ��: localSymbol,action,price,quantity
if  ~isfield(OrderInfo,'quantity') || ~isfield(OrderInfo,'Contract') ...
        || ~isfield(OrderInfo,'action') || OrderInfo.quantity<=0
    % ����Ҫ�������������Ϊ0
    orderId = 0;
    return
end
%����λ�㹻����ƽ��ʱ������ƽ�֣�����λ������ƽ�ֽ׶εĲ�λʱ�����²�
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