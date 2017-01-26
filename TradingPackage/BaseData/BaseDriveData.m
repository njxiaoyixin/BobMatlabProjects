classdef BaseDriveData < handle
    properties(AbortSet, SetObservable) %����Ҫ���õ�ֵ�뵱ǰֵһ�µ�ʱ�򲻴�����Ӧ��PostSet�Լ�PreSet�¼�
        LoginId                         % ���Ӵ��ţ�CTPΪCTPCom object�� IBΪIB Object
        Contract@BaseContract           % ��Լ������Ϣ����һ��Ϊ��Լ��ţ��ڶ���Ϊ��Լ������Ϣ�������IB���������ΪibContract Object
        ConnStatus                      % �뽻�׶�����״̬
        Busy
        TimeLog@BaseTimeLog
        SystemSwitch@BaseSystemSwitch   % ����ϵͳ���أ��ں��Ƿ���isTrade��
    end
    
    methods
        function obj=BaseDriveData
            obj.TimeLog = BaseTimeLog;
            obj.SystemSwitch = BaseSystemSwitch;
        end
    end
end