function [PosDI,NegDI,ADX]=DMI(High,Low,Close,N)
%--------------------�˳�����������DMIָ��(����ָ��)-----------------------
%----------------------------------��д��--------------------------------
%Lian Xiangbin(����,785674410@qq.com),DUFE,2014
%----------------------------------�ο�----------------------------------
%[1]Elder.�Խ���Ϊ��.��е��ҵ�����磬2010��4�µ�1��
%[2]��������.ѧ�����ùؼ�����ָ��
%[3]Wilder.����������ϵͳ�¸��
%----------------------------------���----------------------------------
%����ָ��DMI�ֳ�Ϊ����ָ�꣬������������������ʦ����˹.ά����(Wells Wilder)��
%����ģ������ԭ��������Ѱ��֤ȯ�ǵ������У��ɼ۽��Դ��¸߻��µ͵Ĺ��ܣ����ж�
%������������Ѱ������˫���ľ���㼰�ɼ���˫�������²�����ѭ�����̡�
%----------------------------------�����÷�------------------------------
%1)��+/-DI �ϴ�-/+DI ʱ����ζ�ţ����ǣ��µ�������ǿ���µ������ǣ�����
%һ����/���ź����ɡ���ʱһ����/��DX ����һ��ǿ/������
%2)�� ADX ��ֵ���͵� 20 ���£������ֺ���ʱ����ʱ�ɼ۴���С�������У���
%ADX ͻ�� 40 ����������ʱ���ɼ���������ȷ��.��� ADX �� 50 ���Ϸ�
%ת���£���ʱ�����۹ɼ��������ǻ��µ�����Ԥʾ���鼴����ת�� 
%----------------------------------���ú���------------------------------
%[PosDI,NegDI,ADX]=DMI(High,Low,Close,N)
%----------------------------------����----------------------------------
%High-��߼�����
%Low-��ͼ�����
%Close-���̼�����
%N-��������ָ�������ƽ����ʱ�����ǵ�����
%----------------------------------���----------------------------------
%PosDI-������ָ��
%NegDI-������ָ��
%ADX-����ƽ����

PosDM=zeros(length(High),1);
NegDM=zeros(length(High),1);
TR=zeros(length(High),1);
PosDI=zeros(length(High),1);
NegDI=zeros(length(High),1);
DX=zeros(length(High),1);
ADX=zeros(length(High),1);
for i=N:length(High)
%step1:��������䶯ֵ
if High(i)-High(i-1)>0
PosDM(i)=High(i)-High(i-1);
else PosDM(i)=0;
end
if Low(i-1)-Low(i)>0
NegDM(i)=Low(i-1)-Low(i);
else NegDM(i)=0;
end
if PosDM(i)>0 && NegDM(i)>0
    PosDM(i)=(PosDM(i)>NegDM(i))*PosDM(i);
    NegDM(i)=(PosDM(i)<NegDM(i))*NegDM(i);
end
%step2:������ʵ����
TR(i)=max([abs(High(i)-Low(i)) abs(High(i)-Close(i-1)) abs(Low(i)-Close(i-1))]);
%step3:����N��������ָ��(�ƶ�ƽ��)
PosDI(i)=sum(PosDM(i-N+1:i))/sum(TR(i-N+1:i))*100;
NegDI(i)=sum(NegDM(i-N+1:i))/sum(TR(i-N+1:i))*100;
%step4:��������ƽ����
DX(i)=abs((PosDI(i)-NegDI(i)))/(PosDI(i)+NegDI(i))*100;
ADX(i)=2/(N+1)*DX(i)+(1-2/(N+1))*ADX(i-1);%ָ���ƶ�ƽ��
end
end
