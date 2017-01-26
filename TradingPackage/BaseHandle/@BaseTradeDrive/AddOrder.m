function draftId = AddOrder(obj,contractId,orderInfo,orderStrategyParam)

%��������Բ飬���OrderInfo�бر��Ĳ����Ƿ��У�action
if nargin < 3
    warning('Not Enough Data Input, OrderDraft Adding Failed.')
    return
end
if ~isfield(orderInfo,'action')
    warning('Please Enter the action field into orderInfo, OrderDraft Adding Failed.')
    return
end

if orderInfo.totalQuantity<=0
    %��������С�ڵ���0
    draftId = -1;
    return
end

draftId = numel(obj.OrderDraft)+1;
obj.OrderDraft(draftId,1) = BaseOrderDraft;

% orderInfoĬ�ϱ�Ҫ�Ĳ���
if ~isfield(orderInfo,'orderType')
    orderInfo.orderType = 'LMT';
end
if ~isfield(orderInfo,'orderStrategy')
    orderInfo.orderStrategy = 'LMT';
end

%���ö���Ĭ�ϲ���
%Param��ӵ�е�Field:
obj.OrderDraft(draftId,1).param.PriceShift = 0;  % �۸�ƫ��,����������Է��̿�ƫ��
obj.OrderDraft(draftId,1).param.MinSize    = 1;  % ��С�ҵ����������ڹ�Ʊ����С100�ɵ����ƣ�
obj.OrderDraft(draftId,1).param.MinTick    = []; % ��С
obj.OrderDraft(draftId,1).param.Mark       = 'Spec';
obj.OrderDraft(draftId,1).param.PollTime   = 5;
obj.OrderDraft(draftId,1).param.PollNum    = 1;
obj.OrderDraft(draftId,1).param.BusyMode   = 'queue';
obj.OrderDraft(draftId,1).param.CancelAtEnd= true;
obj.OrderDraft(draftId,1).param.CancelNum  = 10;  % ������ѯ��󳷵�����

switch upper(orderInfo.orderStrategy)
    case {'FOK','FAK'}
        obj.OrderDraft(draftId).param.PollNum = 1;
    case {'BOC','BOP','BOL'} %Ĭ�ϲ���
        obj.OrderDraft(draftId).param.PollNum = 10;
    case {'IBOC'}
        obj.OrderDraft(draftId).param.PollTime = 1;
        obj.OrderDraft(draftId).param.PollNum = 10;
    otherwise %�޼۵���ִֻ��һ��
        obj.OrderDraft(draftId).param.PollNum = 1;
end

if nargin >=4
    fields = fieldnames(orderStrategyParam);
    for i=1:numel(fields)
        thisField = fields{i};
        obj.OrderDraft(draftId).param.(thisField) = orderStrategyParam.(thisField);
    end
end

orderInfo.action  = lower(orderInfo.action(1:end));
%���OrderDraft
obj.OrderDraft(draftId,1).contractId        = contractId;
obj.OrderDraft(draftId,1).orderId           = 0;
obj.OrderDraft(draftId,1).action            = orderInfo.action;
switch upper(obj.OrderDraft(draftId,1).action)
    case{'BUY','COVER'}
        obj.OrderDraft(draftId,1).isBuy     = true;
    case{'SELL','SHORT'}
        obj.OrderDraft(draftId,1).isBuy     = false;
end
if isfield(orderInfo,'lmtPrice')
    obj.OrderDraft(draftId,1).targetPrice = orderInfo.lmtPrice;
end
if isfield(orderInfo,'targetPrice')
    obj.OrderDraft(draftId,1).targetPrice = orderInfo.targetPrice;
end
obj.OrderDraft(draftId,1).orderInfo         = orderInfo;
obj.OrderDraft(draftId,1).totalQuantity     = orderInfo.totalQuantity;          
obj.OrderDraft(draftId,1).orderType         = orderInfo.orderType;          
obj.OrderDraft(draftId,1).orderStrategy     = orderInfo.orderStrategy;
obj.OrderDraft(draftId,1).localSymbol       = obj.Contract(contractId).localSymbol;
obj.OrderDraft(draftId,1).fillQuantity      = 0;     %��ǰ�����ɽ�����
obj.OrderDraft(draftId,1).histFillQuantity  = 0; % ��ʷ�ɽ�����
obj.OrderDraft(draftId,1).totalFillQuantity = 0; %�ܳɽ�����
% Status��6��״̬:Pre_Submitting,Pending,InProgress,Error_InProgress,Finished,Error_Finished
obj.OrderDraft(draftId,1).status            = 'Pre_Submitting' ;
obj.OrderDraft(draftId,1).remark            = '����δ����' ;
obj.OrderDraft(draftId,1).pollNum           = 0;
obj.OrderDraft(draftId,1).pollTimer         = [];
obj.OrderDraft(draftId,1).busy              = 0;
obj.OrderDraft(draftId,1).sysId             = randi(1e6);
obj.OrderDraft(draftId,1).insertTime        = datestr(now,'yyyy-mm-dd HH:MM:SS');
obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
disp([datestr(now,'HH:MM:SS'),'---Order Draft ',num2str(draftId),' Adding Succeeded.---'])
end