function funOnOrder(obj,varargin)
% disp([varargin]);

orderId=varargin{3};% �������3
%����obj.OrderѰ��orderId
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
obj.Order(iOrder,1).localSymbol=varargin{4};% ��Լ���
obj.Order(iOrder,1).isBuy=varargin{5}>0;% �Ƿ�Ϊ��,��0Ϊ��,����Ϊ��;
obj.Order(iOrder,1).isOpen=varargin{6}>0;% �Ƿ񿪲�,��0Ϊ����,����Ϊƽ��
obj.Order(iOrder,1).volume=varargin{7};% ί������
obj.Order(iOrder,1).price=varargin{8};% ί�м۸�
obj.Order(iOrder,1).tradedVolume=varargin{9};%�ѳɽ�����
obj.Order(iOrder,1).avgTradePrice=varargin{10};% �ɽ�����
obj.Order(iOrder,1).orderStatus=varargin{11};% ������ǰ״̬(����)
obj.Order(iOrder,1).orderSysId=varargin{12};% ������������
obj.Order(iOrder,1).insertTime=varargin{13};% ί��ʱ�� ������
obj.Order(iOrder,1).statusMsg=varargin{14};% ״̬��Ϣ������ñ���ʧ�ܣ���Ϊʧ��ԭ��
%�������
obj.Order(iOrder,1).updateTime = datestr(now,31);
obj.TimeLog.Order = datestr(now,31); 

CallbackOnOrderChange(obj,iOrder,varargin)