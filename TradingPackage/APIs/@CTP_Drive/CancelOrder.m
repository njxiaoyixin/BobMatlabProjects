function [cancelId] = CancelOrder(obj,orderId)%����
% IsOpen �������Ƿ�ɳ�
% CancelId �����������Ƿ��ͳɹ���>0��ʾ���ͳɹ�(���ǲ��������ɹ�)
%             IsOpen = IsOrderOpen(obj.LoginId,orderId);%��ָ���ı������г���������
%             if IsOpen>0%�ж�ĳ�������Ƿ��ڿɳ�״̬��
cancelId = CancelOrder(obj.LoginId,orderId);%��ָ���ı������г���������
if cancelId > 0
    disp([datestr(now,'HH:MM:SS'),'---OrderId ',num2str(orderId),' Canceling...---'])
end
%             else
%                 CancelId = -1;
%             end
end