classdef BaseOrder
    properties
        orderId                % �������
        orderSysId             % ϵͳId����
        localSymbol@char       % ����Ψһ�Ե�ticker
        isBuy@logical          % �Ƿ�����
        isOpen@logical         % �Ƿ��ǿ��֣�ֻ������CTP��
        volume                 % �ҵ���
        price@double           % �ҵ��۸�
        tradedVolume           % �ɽ���
        lastFillPrice@double   % ���³ɽ��ļ۸�
        avgTradePrice@double   % ƽ���ɽ���
        orderStatus            % ����״̬��
        statusMsg@char         % ����״̬��Ϣ
        insertTime             % �������ʱ��
        updateTime             % ��������ʱ��
        other                  % ������Ϣ������IB Order�ȣ�
        % IB Order
    end
    
    methods
        function obj = BaseOrder
            obj.orderId=0;
            obj.tradedVolume=0;
            obj.lastFillPrice=0;
            obj.avgTradePrice=0;
            obj.statusMsg = '';
            obj.insertTime = datestr(now,31);
            obj.updateTime = datestr(now,31);
        end
    end
end