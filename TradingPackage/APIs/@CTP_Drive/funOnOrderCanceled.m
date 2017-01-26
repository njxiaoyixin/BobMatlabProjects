function funOnOrderCanceled(obj,varargin)
% OnOrderCanceled	- 当出现报单错误或者报单被撤时，此事件被触发；
% 参数:
% OrderID-报单编号
% ErrorID-当为错单时的错误编号;
% ErrorMsg-当为错单时的错误信息;
%
% OrderID = varargin{3};
% ErrorID = varargin{4};
% ErrorMsg = varargin{5};
% fprintf('%s\tOrderID:%d is canceled\t',datestr(now,'HH:MM:SS.FFF'),OrderID);
% fprintf('ErrorID:%d\tErrorMsg:%s\n',ErrorID,ErrorMsg);


% orderId = varargin{3};
% errorId = varargin{4};
% errorMsg = varargin{5};
% 
% %显示
% dispInfo = [' Order ID: ',num2str(orderId),' - OnOrderCanceled已撤单！错误代码：',num2str(errorId),',错误信息:',errorMsg];
% DispOnOrderCanceled(dispInfo,1)
% 
% try
% if isempty(obj.OrderDraft)
%     return
% end
% 
% currentOrderId = [obj.OrderDraft.orderId];
% idx2 = find(currentOrderId == orderId,1);
% if isempty(idx2)
%     %     warning('Order placed elsewhere! Orderid not found in order draft!')
%     return
% end
% 
% ThisAction = obj.OrderDraft(idx2).orderInfo.action;
% contractId = obj.OrderDraft(idx2).contractId;
% 
% switch upper(obj.OrderDraft(idx2).orderInfo.orderType)
%     case 'FAK'
% 
%     case {'BOC','IBOC','BOP','BOL','LMT'}
%         ErrorList = {'报单被拒绝','仓位不足','下单失败','字段有误','资金不足','平仓量超过持仓量','未连接'};
%         if any(cell2mat(regexp(errorMsg,ErrorList,'Once')))
%             % 停止轮询
%             if ~isempty(obj.OrderDraft(idx2).PollTimer) && obj.OrderDraft(idx2).PollNum > 2 %允许状态异常发生3次后进行撤单
%                 stop(obj.OrderDraft(idx2).PollTimer)
%                 obj.OrderDraft(idx2).status = -1;
%             end
%         end
%     case 'MTL'
%         % 市价剩余转限价
%     otherwise % 限价单
% end
% % 更新订单Busy状态
% obj.Busy(contractId).(ThisAction) = 0;
% catch Err
%     disp(Err.message)
% end
% end
% 
% 
% function DispOnOrderCanceled(dispInfo,number)
% %避免重复显示信息
% %当显示的信息与上次不同时，进行显示，否则只显示一遍
% if nargin <2
%     number = 1;
% end
% persistent dispStr
% if isempty(dispStr)
%     dispStr = cell(2,1);
% end
% 
% if isempty(dispStr{number}) || ~strcmpi(dispInfo,dispStr{number})
%     disp([datestr(now,'HH:MM:SS'),dispInfo])
%     dispStr{number} = dispInfo;
% end
% end