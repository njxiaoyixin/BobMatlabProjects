function funOnOrderCanceled(obj,varargin)
% OnOrderCanceled	- �����ֱ���������߱�������ʱ�����¼���������
% ����:
% OrderID-�������
% ErrorID-��Ϊ��ʱ�Ĵ�����;
% ErrorMsg-��Ϊ��ʱ�Ĵ�����Ϣ;
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
% %��ʾ
% dispInfo = [' Order ID: ',num2str(orderId),' - OnOrderCanceled�ѳ�����������룺',num2str(errorId),',������Ϣ:',errorMsg];
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
%         ErrorList = {'�������ܾ�','��λ����','�µ�ʧ��','�ֶ�����','�ʽ���','ƽ���������ֲ���','δ����'};
%         if any(cell2mat(regexp(errorMsg,ErrorList,'Once')))
%             % ֹͣ��ѯ
%             if ~isempty(obj.OrderDraft(idx2).PollTimer) && obj.OrderDraft(idx2).PollNum > 2 %����״̬�쳣����3�κ���г���
%                 stop(obj.OrderDraft(idx2).PollTimer)
%                 obj.OrderDraft(idx2).status = -1;
%             end
%         end
%     case 'MTL'
%         % �м�ʣ��ת�޼�
%     otherwise % �޼۵�
% end
% % ���¶���Busy״̬
% obj.Busy(contractId).(ThisAction) = 0;
% catch Err
%     disp(Err.message)
% end
% end
% 
% 
% function DispOnOrderCanceled(dispInfo,number)
% %�����ظ���ʾ��Ϣ
% %����ʾ����Ϣ���ϴβ�ͬʱ��������ʾ������ֻ��ʾһ��
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