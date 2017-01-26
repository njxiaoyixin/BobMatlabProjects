function TransmitOrder(obj,draftId,varargin)
%同CTP的一样
% orderInfo要素：
% 常用：action totalQuantity orderStrategy
% 所有: account action activeStartTime activeStopTime algoParams
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
    %Order Draft添加不成功
    return
end

% if ~isfield(obj.OrderDraft(draftId).orderInfo,'orderStrategy')
%     obj.OrderDraft(draftId).orderInfo.orderStrategy='LMT';
% end

% 将代码相同，Action相同的订单过滤掉
% 将订单序列中未成交的序列进行筛选，如果有和当前订单相同的代码和行动，则将其过滤不进行交易
% if ~isempty(obj.Busy)
%     if numel(obj.Busy)>= ThisOrder.contractId && isfield(obj.Busy(ThisOrder.contractId),ThisAction)  && ~isempty(obj.Busy(ThisOrder.contractId).(ThisAction)) && obj.Busy(ThisOrder.contractId).(ThisAction) >0
%         %与当前队列中的订单有重复，不下单
%         disp([datestr(now,'HH:MM:SS'),' Transmit - ',ThisAction,ThisOrder.localSymbol,'与当前活动订单有重复，下单取消'])
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
    %更改默认参数
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