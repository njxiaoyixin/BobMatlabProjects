function TransmitOrder(obj,draftId,varargin)
%ͬCTP��һ��
% orderInfoҪ�أ�
% ���ã�action totalQuantity orderStrategy
% ����: account action activeStartTime activeStopTime algoParams
% algoStrategy allOrNone auctionStrategy auxPrice
%Construct ibOrder

if obj.SystemSwitch.isTrade == 0
    warning('Transmit - Trading shut down. No trade allowed.')
    return
end

if nargin < 2
    warning('Transmit - draftId is indispensable!')
    return
end

if numel(obj.OrderDraft)<0
    warning('Transmit - Order Draft NOT Set!')
    return
end

if draftId <0
    %Order Draft��Ӳ��ɹ�
    return
end

% if ~isfield(obj.OrderDraft(draftId).orderInfo,'orderStrategy')
%     obj.OrderDraft(draftId).orderInfo.orderStrategy='LMT';
% end

% ��������ͬ��Action��ͬ�Ķ������˵�
% ������������δ�ɽ������н���ɸѡ������к͵�ǰ������ͬ�Ĵ�����ж���������˲����н���
% if ~isempty(obj.Busy)
%     if numel(obj.Busy)>= ThisOrder.contractId && isfield(obj.Busy(ThisOrder.contractId),ThisAction)  && ~isempty(obj.Busy(ThisOrder.contractId).(ThisAction)) && obj.Busy(ThisOrder.contractId).(ThisAction) >0
%         %�뵱ǰ�����еĶ������ظ������µ�
%         disp([datestr(now,'HH:MM:SS'),' Transmit - ',ThisAction,ThisOrder.localSymbol,'�뵱ǰ��������ظ����µ�ȡ��'])
%         disp('BusyStatus: ')
%         disp(obj.Busy)
%         return
%     end
% end

try
    thisOrderStrategy = upper(obj.OrderDraft(draftId).orderInfo.orderStrategy);
    obj.OrderDraft(draftId).status = 'Pending';
    obj.OrderDraft(draftId).pollNum = 0;
    obj.OrderDraft(draftId).pollTimer = timer(...
        'Name',thisOrderStrategy,...
        'TimerFcn',@(src,evnt)Fcn_PlaceOrder(obj,draftId,src,evnt),...
        'Period',5,...
        'ExecutionMode','fixedRate',...
        'StartDelay',0, ...
        'TasksToExecute',30,...
        'BusyMode','Queue');
    %����Ĭ�ϲ���
    if ~isempty(obj.OrderDraft(draftId).param)
        fields = fieldnames(obj.OrderDraft(draftId).param);
        for k=1:numel(fields)
            switch fields{k}
                case 'PollTime'
                    set(obj.OrderDraft(draftId).pollTimer,'Period',obj.OrderDraft(draftId).param.(fields{k}));
                case 'BusyMode'
                    set(obj.OrderDraft(draftId).pollTimer,'BusyMode',obj.OrderDraft(draftId).param.(fields{k}));
            end
        end
    end
    switch upper(obj.OrderDraft(draftId).orderStrategy)
        case 'LMT'
          set(obj.OrderDraft(draftId).pollTimer,'TasksToExecute',1);  
    end
    start(obj.OrderDraft(draftId).pollTimer)
catch Err
    disp([datestr(now,'HH:MM:SS'),' Transmit Error: ',Err.message, ' ,line: ',Err.stack(1).line])
end
end