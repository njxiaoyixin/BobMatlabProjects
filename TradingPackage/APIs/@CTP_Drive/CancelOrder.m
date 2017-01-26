function [cancelId] = CancelOrder(obj,orderId)%撤单
% IsOpen 代表订单是否可撤
% CancelId 代表撤单命令是否发送成功，>0表示发送成功(但是不代表撤单成功)
%             IsOpen = IsOrderOpen(obj.LoginId,orderId);%对指定的报单进行撤单操作；
%             if IsOpen>0%判断某个报单是否处于可撤状态。
cancelId = CancelOrder(obj.LoginId,orderId);%对指定的报单进行撤单操作；
if cancelId > 0
    disp([datestr(now,'HH:MM:SS'),'---OrderId ',num2str(orderId),' Canceling...---'])
end
%             else
%                 CancelId = -1;
%             end
end