function funOnOrderActionFailed(obj,varargin)
% OnOrderActionFailed([in] long OrderID,[in] int ErrorID);������ʧ��ʱ�����¼���������
% fprintf('%s\tOrderID: %d is failed\tErrorID is %s\n',datestr(now,'HH:MM:SS.FFF'),varargin{3},varargin{4});

% orderId   = varargin{3};
% errorId   = varargin{4};
% %��ʾ
% dispInfo = [' Order ID: ',num2str(orderId),' - OnOrderActionFailed����ʧ�ܣ�ֹͣ��ѯ��������룺 ',errorId];
% DispOnOrderActionFailed(dispInfo,1)
% 
% end
% 
% 
% function DispOnOrderActionFailed(dispInfo,number)
% %�����ظ���ʾ��Ϣ
% %����ʾ����Ϣ���ϴβ�ͬʱ��������ʾ������ֻ��ʾһ��
% if nargin <2
%     number = 1;
% end
% persistent dispStr
% if isempty(dispStr)
%     dispStr = cell(1,1);
% end
% 
% if isempty(dispStr{number}) || ~strcmpi(dispInfo,dispStr{number})
%     disp([datestr(now,'HH:MM:SS'),dispInfo])
%     dispStr{number} = dispInfo;
% end
% end