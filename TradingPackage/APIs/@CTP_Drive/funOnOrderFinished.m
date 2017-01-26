function funOnOrderFinished(obj,varargin)
% OnOrderFinished – 当某个报单全部成交后，此事件被触发；此事件总是在一个报单的所有OnTrade事件之后发生。
% 参数:
% OrderID 报单编号

% fprintf('%s\tOrderID: %d is finished\n',datestr(now,'HH:MM:SS.FFF'),varargin{3});

% orderId = varargin{3};
% % 显示
% dispInfo = [' Order ID: ',num2str(orderId),' - OnOrderFinished全部报单已成交或撤单！'];
% DispOnOrderFinished(dispInfo,1)
% end
% 
% 
% function DispOnOrderFinished(dispInfo,number)
% %避免重复显示信息
% %当显示的信息与上次不同时，进行显示，否则只显示一遍
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