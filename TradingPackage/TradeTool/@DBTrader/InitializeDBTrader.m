function InitializeDBTrader(obj)
%Ĭ��Ϊ��½����CTP�˺ţ�һ���������飬һ�����н��ף�����������
AddTradeObj('CTP');
AddTradeObj('CTP');
%���������Ĭ�ϵ�ģ���˺ţ������׵��˺ŵ�������
LoginParam1.FuturesBroker = '���Ž�Ͷ';
LoginParam1.Username      = '10950829';
LoginParam1.Password     = '998429';
%             LoginParam1.FuturesBroker = '���ڼ���';
%             LoginParam1.Username      = '047328';
%             LoginParam1.Password     = '2277565';
PresetLoginParam(obj,1,LoginParam1)
LoginParam2.FuturesBroker = '���ڼ���';
LoginParam2.Username      = '063098';
LoginParam2.Password     = '998429';
%             LoginParam2.FuturesBroker = '���Ž�Ͷ';
%             LoginParam2.Username      = '10950829';
%             LoginParam2.Password     = '998429';
PresetLoginParam(obj,2,LoginParam2)
obj.LoginTradeObj; %��½���н���
end