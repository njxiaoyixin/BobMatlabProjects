function funOnOrderFinished(obj,varargin)
% OnOrderFinished �C ��ĳ������ȫ���ɽ��󣬴��¼������������¼�������һ������������OnTrade�¼�֮������
% ����:
% OrderID �������

% fprintf('%s\tOrderID: %d is finished\n',datestr(now,'HH:MM:SS.FFF'),varargin{3});

% orderId = varargin{3};
% % ��ʾ
% dispInfo = [' Order ID: ',num2str(orderId),' - OnOrderFinishedȫ�������ѳɽ��򳷵���'];
% DispOnOrderFinished(dispInfo,1)
% end
% 
% 
% function DispOnOrderFinished(dispInfo,number)
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