% trader class sample

%-------------��ʼ��ģ��--------------------
TC = 0.001;
InitialFund = 1000000;
s = trader(TC,InitialFund);
%��ʼ���趨ʱ������-ע������ʹ�������и���
ThisTimeSeries.TimeVec=HF.(Product_List{i}).TimeVec;
T1.PreSetTimeSeries(ThisTimeSeries)
T2.PreSetTimeSeries(ThisTimeSeries)

%�ֶ��趨trader������
s.SetProperties('InitialFund',1000000);

s.SetFx(Fx)
%-------------��Ϣ��ȡģ��--------------------
%��ȡ��ǰͷ��
s.GetPosition;

%��ȡ��ǰ��λ����ӯ��

%��ȡtrader������
ts=s.GetProperties('TimeSeries');

%--------------����ģ��------------------------
%����
%iΪ��ѡ���������趨��TimeSeries����������뵱ǰ�۸���TimeSeries���е�����
s.buy(time,price,quantity,i);

%����
s.sell(time,price,quantity,i);

%ƽ��ͷ
s.closeshort(time,price,quantity,i);

%ƽ��ͷ
s.closelong(time,price,quantity,i);

%ƽ����ǰͷ��
coverall(obj,time,price,[],i)

%���µ�ǰ״̬��ÿһ�����ݵ���󶼱�����£�
s.update(time,price,i)

%---------�ʽ����ģ��,ע����ʼ�ʽ𲻿���Ϊ0----
%�����ʽ�
s.AddFund(ThisFund,i)

s.ExtractFund(obj,ThisFund,i)

%-------------����ģ��------------------------
%�����и�Ƶ�ز�ʱ��TimeSeries�趨Ϊһ�������ÿ��Ľ��ײ�����Ϻ��������(������DailyCalc����)
% DateΪ��ѡ������Ϊ���������
s.DailyClearance(Date)

%���е���ʷ������ɺ󣬽����γ�������������
s.DailyCalc;

%����Daily�ĸ������������㽻�ױ���
s.OutputCalc;


