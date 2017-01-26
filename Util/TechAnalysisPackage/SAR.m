function [SARofCurBar,SARofNextBar,Position,Transition]=SAR(High,Low,a,b)
%--------------------�˳�����������SARָ��(������ָ��)---------------------
%----------------------------------��д��--------------------------------
%Lian Xiangbin(����,785674410@qq.com),DUFE,2014
%----------------------------------�ο�----------------------------------
%[1]Wilder.����������ϵͳ�¸��
%[2]����ʤ.ָ�꾫�ͣ����似��ָ�꾫��������.������ѧ������,2004��01�µ�1��
%[3]���׿�����.parabolicSAR�������㷨
%[4]����֤ȯ.����ָ���Ż���ʱ��10��30������,2010-12-23
%----------------------------------���----------------------------------
%SAR (Stop and Reveres)ָ���ֽ�������ָ���ͣ��ָ�꣬������������������
%ʦ����˹-�����£�Wells Wilder��������ġ�SAR֮���Գ�Ϊͣ��ָ�꣬����Ϊ��
%�ǻ������µ�ͣ����Զ���Ƶġ���ͣ�������������ĳ����Ʊ֮ǰ����Ҫ�趨һ
%��ֹ���λ���Լ���Ͷ�ʷ��ա������ֹ���λҲ����һ�ɲ���ģ������Źɼ۵�
%����ֹ��λ�����ϵ������������ȿ�����Ч�ؿ���סǱ�ڷ��գ��ֲ����ʧ������
%���ᡣSAR�ĵڶ��㺬���ǡ�Reverse��������ת���������֮�⣬���۸�ﵽֹ��
%��λʱ��Ͷ���߲���Ҫ��ǰ������Ĺ�Ʊ����ƽ�֣�����Ҫ��ƽ�ֵ�ͬʱ���з���
%���ղ�������ı���������󻯡�
%----------------------------------�����÷�------------------------------
%1)���۸��SAR�����·���ʼ����ͻ��SAR����ʱ��Ϊ�����ź�
%2)���۸��SAR�����Ϸ���ʼ���µ���SAR����ʱ��Ϊ�����ź�
%----------------------------------���ú���------------------------------
%[SARofCurBar,SARofNextBar,Position,Transition]=SAR(a,b)
%----------------------------------����----------------------------------
%a-��ʼ��������
%b-�������ӵ����ֵ
%----------------------------------���----------------------------------
%SARofCurBar-��ǰBar��ͣ��ֵ
%SARofNextBar-��һ��Bar��ͣ��ֵ
%Position-�������ĳֲ�״̬��1-��ͷ��-1-��ͷ
%Transition-��ǰBar��״̬�Ƿ�����ת��1��-1Ϊ��ת��0Ϊ���ֲ���

AfStep=a;%��ʼ�������ӣ�Ҳ�ǲ���
AfLimit=b;%�������ӵ����ֵ
%�������
L=length(DateTime);
Af=zeros(L,1);%��������
SARofCurBar=zeros(L,1);%��ǰBar��SARֵ
SARofNextBar=zeros(L,1);%��һ��Bar��SARֵ
Position=zeros(L,1);%����ĳֲ�״̬��1-��ͷ��-1��ͷ
Transition=0;%����Ƿ�����ת��1��ʾ��תΪ��ͷ��-1��ʾ��תΪ��ͷ��0Ϊ���ֲ���
HighestPoint=zeros(L,1);%��ת���������ߵ�
LowestPoint=zeros(L,1);%��ת���������͵�
%�������
for i=1:L
    %��һ��Bar�״ν��룬����Ϊ��ͷ
    if i==1
        Position(i)=1;
        Transition=1;
        Af(i)=AfStep;
        HighestPoint(i)=High(i);
        LowestPoint(i)=Low(i);
        SARofCurBar(i)=LowestPoint(i);
        SARofNextBar(i)=SARofCurBar(i)+Af(i)*(HighestPoint(i)-SARofCurBar(i));
        if SARofNextBar(i)>Low(i)
            SARofNextBar(i)=Low(i);
        end       
    end
    %����Bar
    if i>1
        Transition=0;
        %�жϷ�ת���������ߵ����͵�
        HighestPoint(i)=max(High(i),HighestPoint(i-1));
        LowestPoint(i)=min(Low(i),LowestPoint(i-1));
        %��ͷ������
        if Position(i-1)==1
            %������㷴ת����
            if Low(i)<=SARofNextBar(i-1)
                Position(i)=-1;
                Transition=-1;
                SARofCurBar(i)=HighestPoint(i);
                HighestPoint(i)=High(i);
                LowestPoint(i)=Low(i);
                Af(i)=AfStep;
                SARofNextBar(i)=SARofCurBar(i)+Af(i)*(LowestPoint(i)-SARofCurBar(i));
                SARofNextBar(i)=max([SARofNextBar(i) High(i) High(i-1)]);
            %��������㷴ת����
            else
                Position(i)=Position(i-1);
                SARofCurBar(i)=SARofNextBar(i-1);
                if HighestPoint(i)>HighestPoint(i-1) && Af(i-1)<AfLimit
                    if Af(i-1)+AfStep>AfLimit
                        Af(i)=AfLimit;
                    else
                        Af(i)=Af(i-1)+AfStep;
                    end
                else
                    Af(i)=Af(i-1);
                end
               SARofNextBar(i)=SARofCurBar(i)+Af(i)*(HighestPoint(i)-SARofCurBar(i));
               SARofNextBar(i)=min([SARofNextBar(i) Low(i) Low(i-1)]);
            end
        end
        %��ͷ������
        if Position(i-1)==-1
            %������㷴ת����
            if High(i)>=SARofNextBar(i-1)
                Position(i)=1;
                Transition=1;
                SARofCurBar(i)=LowestPoint(i);
                HighestPoint(i)=High(i);
                LowestPoint(i)=Low(i);
                Af(i)=AfStep;
                SARofNextBar(i)=SARofCurBar(i)+Af(i)*(HighestPoint(i)-SARofCurBar(i));
                SARofNextBar(i)=min([SARofNextBar(i) Low(i) Low(i-1)]);
            %��������㷴ת����
            else
                Position(i)=Position(i-1);
                SARofCurBar(i)=SARofNextBar(i-1);
                if LowestPoint(i)<LowestPoint(i-1) && Af(i-1)<AfLimit
                    if Af(i-1)+AfStep>AfLimit
                        Af(i)=AfLimit;
                    else
                        Af(i)=Af(i-1)+AfStep;
                    end
                else
                    Af(i)=Af(i-1);
                end
                SARofNextBar(i)=SARofCurBar(i)+Af(i)*(LowestPoint(i)-SARofCurBar(i));
                SARofNextBar(i)=max([SARofNextBar(i) High(i) High(i-1)]);
            end
        end
    end
end


end

