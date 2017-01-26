function funOnRisk(obj,varargin)
% persistent OpenRiskEngine
% if isempty(OpenRiskEngine)
%     disp('风控引擎已打开！')
%     OpenRiskEngine = 1;
% end
% 
% % 1.异常单提醒
% 
% % 2.开仓到达上限，平掉所有仓位，退出系统
% % 用Account里面的信息来判断,以占用保证金上限来进行约束
% Max_Margin = 10000;
% if obj.TradeObj{2}.Account.Margin > Max_Margin
%     disp('单日开仓达到上限，清仓！')
%     obj.TradeObj{2}.SystemSwitch.isAllClear = 1;
%     pause(60)
%     obj.PauseStrategy;
%     obj.Listeners{1}.delete
%     return
% end
% 
% % 3. 单日亏损到达上限，平掉所有仓位，退出系统
% Min_CloseProfit = -3000;
% if obj.TradeObj{2}.Account.CloseProfit < Min_CloseProfit
%     disp('单日亏损达到上限，清仓！')
%     obj.TradeObj{2}.SystemSwitch.AllClear = 1;
%     pause(60)
%     obj.PauseStrategy;
% %     obj.Listeners{1}.delete
%     return
% end
end