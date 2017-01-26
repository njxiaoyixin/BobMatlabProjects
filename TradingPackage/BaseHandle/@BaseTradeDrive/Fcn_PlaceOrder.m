function Fcn_PlaceOrder(obj,draftId,varargin)
% ���ڽ�����ѯ�µ��Ļص�����,��ѯ�Ĳ�����Transmit�������ú�,�洢��OrderDraft��orderInfo��

% ********** 1. ��ѯ�ж�ģ��**********
if obj.OrderDraft(draftId,1).busy
    return
end
obj.OrderDraft(draftId,1).busy              = 1;
try
    % ����3�������Ҫֹͣ��ѯ
    % 1. ��OrderDraft���е�totalQuantity�Ѿ�ȫ���ɽ�(�ɽ��ر�ͨ��OnOrder���и���)
    % 2. ����ѯ������������ʱ,���г�������
    % 3. ���ⲿִ����CancelOrderʱ������Param�е�CancelAtEnd�������г�����������ֹͣ��ѯ
    % 4. ��1,2��3��������ʱ,���Խ��г�������δ�ɽ���Order�޷����г���ʱ,��ʱ���������Ѿ�ȫ���ɽ��򶩵�δ�ɹ�����
    
    obj.OrderDraft(draftId)  = obj.OrderDraft(draftId);
    thisAction = [upper(obj.OrderDraft(draftId).orderInfo.action(1)),lower(obj.OrderDraft(draftId).orderInfo.action(2:end))];
    thisOrderStrategy = upper(obj.OrderDraft(draftId).orderInfo.orderStrategy);
    if any(strcmpi(obj.OrderDraft(draftId).status,{'Finished','Error_Finished'}))
        if ~isempty(obj.OrderDraft(draftId).pollTimer)
            stop(obj.OrderDraft(draftId).pollTimer)
        end
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ����״̬�ѽ���!'])
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
        return
    end
    % ����Ѿ�ȫ���ɽ�����ֹͣ��ѯ
    if obj.OrderDraft(draftId).totalFillQuantity>=obj.OrderDraft(draftId).orderInfo.totalQuantity
        % ֹͣ��ѯ
        if ~isempty(obj.OrderDraft(draftId).pollTimer)
            stop(obj.OrderDraft(draftId).pollTimer)
        end
        obj.OrderDraft(draftId).status = 'Finished';
        obj.OrderDraft(draftId).remark = 'ȫ���ɽ�';
        %����Busy״̬
        obj.Busy(obj.OrderDraft(draftId).contractId).(thisAction) = 0;
        %��ʾ
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ȫ�������ѳɽ�,��ѯ����!'])
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
        return
    end
    % �����ѯ��������,��ֹͣ��ѯ
    if obj.OrderDraft(draftId).pollNum >= obj.OrderDraft(draftId).param.PollNum
        %ֹͣ��ѯ
        if ~isempty(obj.OrderDraft(draftId).pollTimer)
            stop(obj.OrderDraft(draftId).pollTimer)
        end
        obj.OrderDraft(draftId).status = 'Finished';
        obj.OrderDraft(draftId).remark = '��ѯ��������,״̬�Ѷ�';  % ��funOnOrder�У������˱�־������������Fcn_PlaceOrder
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ��ѯ��������,״̬�Ѷ���'])
        if obj.OrderDraft(draftId).param.CancelAtEnd
            obj.CancelOrder(obj.OrderDraft(draftId).orderId);
            obj.OrderDraft(draftId).remark = '��ѯ��������,��״̬δ��';  % ��funOnOrder�У������˱�־������������Fcn_PlaceOrder
        end
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
        return
    end
    %���ִ����CancelDraftOrder���򳷵�����ֹͣ��ѯ
    if strcmpi(obj.OrderDraft(draftId).remark,'��ֹͣ')
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ��ѯ��ѯ���ֶ�ֹͣ��'])
        return
    end
    %������������Ѿ��������ޣ���ֹͣ��ѯ
    if obj.OrderDraft(draftId).cancelNum >= obj.OrderDraft(draftId).param.CancelNum
        %ֹͣ��ѯ
        if ~isempty(obj.OrderDraft(draftId).pollTimer)
            stop(obj.OrderDraft(draftId).pollTimer)
        end
        obj.OrderDraft(draftId).status = 'Error_Finished';
        obj.OrderDraft(draftId).remark = '����Գ�����������';  % ��funOnOrder�У������˱�־������������Fcn_PlaceOrder
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ����Գ����������'])
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,31);
        return
    end
    % ����������ί��
    if obj.OrderDraft(draftId).pollNum>=1
        if obj.OrderDraft(draftId).totalFillQuantity >0
            obj.OrderDraft(draftId).status = 'InProgress';
            %             obj.OrderDraft(draftId).remark = '���ֳɽ�';
        end
        % �ж�Ӧ�ü����µ�������Ӧ�ó����ϸ���ѯδ�ɽ��Ķ���
        %         isOpen = IsOrderOpen(obj.LoginId,obj.OrderDraft(draftId).orderId);
        %         if isOpen  % IsOrderOpen��������Bug
        if any(strcmpi(obj.OrderDraft(draftId).status,{'InProgress','Error_InProgress'})) && ~strcmpi(obj.OrderDraft(draftId).remark,'�ѳ���')
            %�����ǰ�л�Ծ�Ķ������򳷵���Ȼ������Fcn_PlaceOrder����funOnOrder���س������������µ�
            currentOrderId = [obj.Order.orderId];
            for i=1:numel(obj.OrderDraft(draftId).orderId)
                thisOrderId = obj.OrderDraft(draftId).orderId(i);
                if isempty(currentOrderId)
                    oSet = [];
                else
                    oSet = find(thisOrderId==currentOrderId);
                end
                if ~isempty(oSet)
                    [cancelId] = obj.CancelOrder(thisOrderId);
                else
                    cancelId = -1;
                end
            end
            obj.OrderDraft(draftId).cancelNum = obj.OrderDraft(draftId).cancelNum+1;
            %             if cancelId <=0
            %                 % ������ѯ״̬
            %                 obj.OrderDraft(draftId).status = 'Error_InProgress';
            %                 obj.OrderDraft(draftId).remark = '����ʧ��';
            %                 %����Busy״̬
            %                 %                 obj.Busy(obj.lOrderDraft(draftId).contractId).(thisAction) = 0;
            %                 %��ʾ
            %                 disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ��ѯ����ʧ��'])
            %                 obj.OrderDraft(draftId,1).busy = 0;
            %                 obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
            %                 return
            %             else
            obj.OrderDraft(draftId).status = 'InProgress';
            obj.OrderDraft(draftId).remark = '���������ѷ���';
            disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ���������ѷ���,�ȴ�OnOrder�����ر�'])
            obj.OrderDraft(draftId,1).busy = 0;
            obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
            return
            %             end
        elseif any(strcmpi(obj.OrderDraft(draftId).status,{'InProgress','Error_InProgress'}))
            %ע����Pending��ʱ�������δ������ɽ��ر�δ��ã���Ҫ��������µ�
            %������������µ�
        else
            switch obj.OrderDraft(draftId).status
                case 'Pending'
                    disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ����δ���ͳɹ���ɽ��ر�δ���أ��ݲ��µ�'])
                otherwise
                    disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ��֧���µ���Status:',obj.OrderDraft(draftId).status])
            end
            return
        end
    else
        %�״���ѯ��������������µ�
    end
catch Err
    disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ֹͣ��ѯ�ж�ʧ��,ʧ��ԭ��',Err.message,',������',num2str(Err.stack(1).line)])
end

%% ********* 2. ʵʱ�����ж�ģ�� **********
obj.OrderDraft(draftId).pollNum   = obj.OrderDraft(draftId).pollNum+1;  %������ѯ����
obj.OrderDraft(draftId).cancelNum = 0;%��ճ�������
% ������������Ϊ������һ��Return���������ε����ҲӦ����һ����ѯ
if ~strcmpi(thisOrderStrategy,'LMT')  %�޼۵������ж�����
    try
        if isempty(obj.MarketData) || isempty(obj.MarketData(obj.OrderDraft(draftId).contractId)) || isempty(obj.MarketData(obj.OrderDraft(draftId).contractId).lastPrice)
            obj.GetMarketData(obj.OrderDraft(draftId).contractId);
        end
    catch Err
        disp(Err.message)
        obj.OrderDraft(draftId,1).busy = 0;
        return
    end
    try
        if isempty(obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice) || ...
                isempty(obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice) ||...
                obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice == 0 || ...
                obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice == 0
            %         %�������Ϊ0������������
            %         if ~isempty(obj.OrderDraft(draftId).pollTimer)
            %             stop(obj.OrderDraft(draftId).pollTimer)
            %         end
            %  ������ѯ״̬
            obj.OrderDraft(draftId).status = 'Error_InProgress';
            obj.OrderDraft(draftId).remark = '�۸�Ϊ��,�޷�����';
            %����Busy״̬
            obj.Busy(obj.OrderDraft(draftId).contractId).(thisAction) = 0;
            disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ��ѯʧ��,',obj.Contract(obj.OrderDraft(draftId).contractId).localSymbol,obj.OrderDraft(draftId).remark])
            obj.OrderDraft(draftId,1).busy = 0;
            return
        end
    catch Err
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - ʵʱ�����ж�ģ�����,����ԭ��',Err.message])
        obj.OrderDraft(draftId,1).busy = 0;
        return
    end
end
%% ********** 3.������������ģ�� **********
thisQuantity = obj.OrderDraft(draftId).orderInfo.totalQuantity-obj.OrderDraft(draftId).totalFillQuantity;
if isempty(obj.OrderDraft(draftId).param.MinTick) || obj.OrderDraft(draftId).param.MinTick==0
    Param.TickSize   = obj.Contract(obj.OrderDraft(draftId).contractId).minTick; %ÿ��tick�Ĵ�С
end
if isempty(Param.TickSize) || Param.TickSize<=0
    Param.TickSize=0;
end
Param.PriceShift = obj.OrderDraft(draftId).param.PriceShift; %���Է��̿�ƫ�Ƶ�Tick�����������������Է��̿ڱ��ˣ����������������̿ڱ���

switch upper(thisOrderStrategy)
    % ��Բ�ͬ�Ķ�������,���ò�ͬ���޼ۼ۸��޼���
    case 'FOK'
        % ��������̿��Ƿ����㹻����,���û���򳷵�(��Ϊֻ�ܿ���һ������,����ֻ�ж�һ������)
        if any(strcmpi(thisAction,{'BUY','COVER'}))
            if obj.OrderDraft(draftId).orderInfo.lmtPrice >=obj.MarketData(idx).askPrice  && obj.OrderDraft(draftId).orderInfo.totalQuantity >= obj.MarketData(idx).AskSize
                thisPrice = obj.MarketData(idx).askPrice+Param.TickSize*Param.PriceShift;
            else % ������,ֱ�ӳ���
                thisPrice = -1;
            end
        elseif any(strcmpi(thisAction,{'SELL','SHORT'}))
            if obj.OrderDraft(draftId).orderInfo.lmtPrice <=obj.MarketData(idx).bidPrice  && obj.OrderDraft(draftId).orderInfo.totalQuantity >= obj.MarketData(idx).BidSize
                thisPrice = obj.MarketData(idx).bidPrice-Param.TickSize*Param.PriceShift;
            else
                thisPrice = -1;
            end
        end
    case 'FAK'
        % �µ��ɹ���ֱ�ӳ��������ֳɽ���ȫ���ɽ�������������onOrder�г�����
        thisPrice = obj.OrderDraft(draftId).orderInfo.lmtPrice;
    case {'BOC','IBOC'}
        % ��һ���Ķ��ּ۽����µ�,IBOC����Ϊ��ѯʱ����̵�BOC����
        switch upper(thisAction)
            case {'BUY','COVER'}
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice-Param.TickSize*Param.PriceShift;
        end
    case 'BOP'
        % �ڱ����̿ڼ۽����µ�
        switch upper(thisAction)
            case {'BUY','COVER'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice-Param.TickSize*Param.PriceShift;
        end
    case 'BOL'
        % �����¼۽����µ�
        switch upper(thisAction)
            case {'BUY','COVER'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).lastPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).lastPrice-Param.TickSize*Param.PriceShift;
        end
    case 'BOV'
        % ��һ���Ա����̿��µ����ڶ��������¼��µ����������ԶԷ��̿��µ�
        switch upper(thisAction)
            case {'BUY','COVER'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).lastPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).lastPrice-Param.TickSize*Param.PriceShift;
        end
    otherwise % �޼۵�
        switch upper(thisAction)
            case {'BUY','COVER'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice;
                thisPrice = obj.OrderDraft(draftId).orderInfo.lmtPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice;
                thisPrice = obj.OrderDraft(draftId).orderInfo.lmtPrice-Param.TickSize*Param.PriceShift;
        end
end
%% ********** 4. �µ�ģ�� **********
try
    if thisPrice > 10e7 || thisPrice <= 0.01 %ȥ���쳣�۸�
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - �����۸�',num2str(thisPrice),'����10e7,�����쳣,Dump!'])
        orderId = -1;
    elseif strcmpi(thisOrderStrategy,'FOK') && thisPrice <0 %FOK������Ѿ�����
        orderId = -1;
        disp([datestr(now,'HH:MM:SS'),' Order ID: ',num2str(orderId),' - ',obj.OrderDraft(draftId).localSymbol,' ',obj.OrderDraft(draftId).orderInfo.thisOrderStrategy,'-',thisAction,'����,','�����۸�',num2str(obj.OrderDraft(draftId).orderInfo.lmtPrice),',������',num2str(thisQuantity),',��ѯ����',num2str(obj.OrderDraft(draftId).pollNum+1)]);
        disp([datestr(now,'HH:MM:SS'),' FOK�����̿�������,�ѳ���!'])
    else
        OrderInfo.Contract  = obj.Contract(obj.OrderDraft(draftId).contractId);
        OrderInfo.action    = thisAction;
        OrderInfo.quantity  = thisQuantity;
        OrderInfo.price     = thisPrice;
        OrderInfo.orderType = obj.OrderDraft(draftId).orderType;
        orderId = obj.BaseTransmit(OrderInfo);
        disp([datestr(now,'HH:MM:SS'),' Order ID: ',num2str(orderId),' - ',obj.OrderDraft(draftId).localSymbol,' ',thisOrderStrategy,'-',thisAction,'����, �����۸�: ',num2str(thisPrice),', ����: ',num2str(thisQuantity),', ��ѯ����: ',num2str(obj.OrderDraft(draftId).pollNum)]);
    end
catch Err
    disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - �µ�ģ���쳣,�쳣ԭ��:',Err.message,', �쳣����:',num2str(Err.stack(1).line)])
    obj.OrderDraft(draftId,1).busy = 0;
    return
end
%% ********** 5. ��������ܽ� **********
if orderId > 0 || (strcmpi(thisOrderStrategy,'FOK') && thisPrice <0)
    obj.OrderDraft(draftId).status = 'Pending';
    obj.OrderDraft(draftId).remark = '��ѯ��';
    disp([datestr(now,'HH:MM:SS'),' Order ID: ',num2str(orderId),' - �����ɹ�.�ȴ��ɽ��ر�...'])
    % ���¶���Busy״̬
    obj.Busy(obj.OrderDraft(draftId).contractId).(thisAction) = 1;
else
    obj.OrderDraft(draftId).status = 'Error_Finished';
    obj.OrderDraft(draftId).remark = '��ѯʧ��: �µ�ʧ��';
    disp([datestr(now,'HH:MM:SS'),' Order ID: ',num2str(orderId),' - ����ʧ��. ֹͣ��ѯ.'])
    % ����ʧ�ܺ�ֹͣ��ѯ
    if ~isempty(obj.OrderDraft(draftId).pollTimer)
        stop(obj.OrderDraft(draftId).pollTimer)
    end
    obj.Busy(obj.OrderDraft(draftId).contractId).(thisAction) = 0;
end
%��������
obj.OrderDraft(draftId).orderId    = orderId;
obj.OrderDraft(draftId).allOrderId(1,end+1) = orderId;
obj.OrderDraft(draftId,1).busy = 0;
end
