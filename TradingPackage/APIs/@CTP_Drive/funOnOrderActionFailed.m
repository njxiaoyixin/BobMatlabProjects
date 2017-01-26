function funOnOrderActionFailed(obj,varargin)
% OnOrderActionFailed([in] long OrderID,[in] int ErrorID);当撤单失败时，此事件被触发；
% fprintf('%s\tOrderID: %d is failed\tErrorID is %s\n',datestr(now,'HH:MM:SS.FFF'),varargin{3},varargin{4});

% orderId   = varargin{3};
% errorId   = varargin{4};
% %显示
% dispInfo = [' Order ID: ',num2str(orderId),' - OnOrderActionFailed撤单失败，停止轮询，错误代码： ',errorId];
% DispOnOrderActionFailed(dispInfo,1)
% 
% end
% 
% 
% function DispOnOrderActionFailed(dispInfo,number)
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