function funOnRisk(obj,varargin)
% persistent OpenRiskEngine
% if isempty(OpenRiskEngine)
%     disp('��������Ѵ򿪣�')
%     OpenRiskEngine = 1;
% end
% 
% % 1.�쳣������
% 
% % 2.���ֵ������ޣ�ƽ�����в�λ���˳�ϵͳ
% % ��Account�������Ϣ���ж�,��ռ�ñ�֤������������Լ��
% Max_Margin = 10000;
% if obj.TradeObj{2}.Account.Margin > Max_Margin
%     disp('���տ��ִﵽ���ޣ���֣�')
%     obj.TradeObj{2}.SystemSwitch.isAllClear = 1;
%     pause(60)
%     obj.PauseStrategy;
%     obj.Listeners{1}.delete
%     return
% end
% 
% % 3. ���տ��𵽴����ޣ�ƽ�����в�λ���˳�ϵͳ
% Min_CloseProfit = -3000;
% if obj.TradeObj{2}.Account.CloseProfit < Min_CloseProfit
%     disp('���տ���ﵽ���ޣ���֣�')
%     obj.TradeObj{2}.SystemSwitch.AllClear = 1;
%     pause(60)
%     obj.PauseStrategy;
% %     obj.Listeners{1}.delete
%     return
% end
end