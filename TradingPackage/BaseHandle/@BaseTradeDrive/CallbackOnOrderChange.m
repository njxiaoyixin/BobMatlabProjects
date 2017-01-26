function CallbackOnOrderChange(obj,iOrder,varargin)
% CTP��draftId�Ĳ��ҿ���0.002,��quantity�ĸ��¿���0.006,��OrderDraft״̬���µ�ʱ��0.004
% IB��draftId�Ĳ��ҿ���0.0006,��quantity�ĸ��¿���0.02,��OrderDraft״̬���µ�ʱ��0.02
try
    % ���OrderDraftδ�������ã��򷵻�
    if isempty(obj.OrderDraft) || ~exist('iOrder','var')
        return
    end
    orderId = obj.Order(iOrder,1).orderId;
    draftId = 0;
    for i=1:numel(obj.OrderDraft)
        for j=1:numel(obj.OrderDraft(i).orderId)
            if obj.OrderDraft(i).orderId(j)==orderId
                draftId = i;
                break
            end
        end
    end
    if draftId<=0
        return
    end
    thisAction = [upper(obj.OrderDraft(draftId).orderInfo.action(1)),lower(obj.OrderDraft(draftId).orderInfo.action(2:end))];
    contractId = obj.OrderDraft(draftId).contractId;
    
    %��orderId���������е�orderIdʱ
    %{
    obj.OrderDraft(draftId).totalFillQuantity = 0;
    obj.OrderDraft(draftId).avgTradePrice     = 0;
    if ~isempty(obj.Order)
        currentOrderId = [obj.Order.orderId];
        if ~isempty(currentOrderId)
            for i=1:numel(obj.OrderDraft(draftId).orderId)
                thisOrderId = obj.OrderDraft(draftId).orderId(i);
                if isempty(thisOrderId)
                    continue
                end
                thisOrderPosition = find(currentOrderId == thisOrderId,1);
                if isempty(thisOrderPosition)
                    continue
                end
                if obj.Order(thisOrderPosition).tradedVolume~=0 && ~isempty(obj.Order(thisOrderPosition).avgTradePrice)...
                        && ~isempty(obj.Order(thisOrderPosition).tradedVolume) && ~isnan(obj.Order(thisOrderPosition).avgTradePrice) ...
                        && ~isnan(obj.Order(thisOrderPosition).tradedVolume)
                    obj.OrderDraft(draftId).avgTradePrice = (obj.OrderDraft(draftId).avgTradePrice*obj.OrderDraft(draftId).totalFillQuantity+...
                        obj.Order(thisOrderPosition).tradedVolume*obj.Order(thisOrderPosition).avgTradePrice)/...
                        (obj.OrderDraft(draftId).totalFillQuantity+obj.Order(thisOrderPosition).tradedVolume);
                    obj.OrderDraft(draftId).totalFillQuantity = obj.OrderDraft(draftId).totalFillQuantity + obj.Order(thisOrderPosition).tradedVolume;
                end
            end
        end
    end
    %}
    
    %��ֻ����һ��orderIdʱ
    if obj.Order(iOrder).tradedVolume~=0 && ~isempty(obj.Order(iOrder).avgTradePrice) && ~isempty(obj.Order(iOrder).tradedVolume) && ~isnan(obj.Order(iOrder).avgTradePrice) && ~isnan(obj.Order(iOrder).tradedVolume)
        obj.OrderDraft(draftId).avgTradePrice = (obj.Order(iOrder).avgTradePrice*obj.Order(iOrder).tradedVolume+...
            obj.OrderDraft(draftId).histTradePrice*obj.OrderDraft(draftId).histFillQuantity)/...
            (obj.Order(iOrder).tradedVolume+obj.OrderDraft(draftId).histFillQuantity);
    else
        obj.OrderDraft(draftId).avgTradePrice = obj.OrderDraft(draftId).histTradePrice;
    end
    if obj.OrderDraft(draftId).avgTradePrice ~=0 && obj.OrderDraft(draftId).targetPrice ~=0
        obj.OrderDraft(draftId).impactCost = obj.OrderDraft(draftId).avgTradePrice/obj.OrderDraft(draftId).targetPrice-1;
        if ~obj.OrderDraft(draftId).isBuy
            obj.OrderDraft(draftId).impactCost = -obj.OrderDraft(draftId).impactCost;
        end
    end
    obj.OrderDraft(draftId).fillQuantity = obj.Order(iOrder).tradedVolume;
    obj.OrderDraft(draftId).totalFillQuantity = obj.OrderDraft(draftId).fillQuantity+obj.OrderDraft(draftId).histFillQuantity;
    
    switch upper(obj.OrderDraft(draftId).orderInfo.orderStrategy)
        case 'FAK'
            % �µ��ɹ���ֱ�ӳ��������ֳɽ���ȫ���ɽ���������
            obj.CancelOrder(obj.OrderDraft(draftId).orderId);
            %������ѯ״̬
            obj.OrderDraft(draftId).status = 'Finished';%������
            obj.OrderDraft(draftId).remark = 'ȫ���ɽ�';%������
            %��תHist
            if ~isnan(obj.OrderDraft(draftId).avgTradePrice) && obj.OrderDraft(draftId).avgTradePrice~=0
                obj.OrderDraft(draftId).histTradePrice = obj.OrderDraft(draftId).avgTradePrice;
            else
                obj.OrderDraft(draftId).histTradePrice = 0;
            end
            if ~isnan(obj.OrderDraft(draftId).totalFillQuantity) && obj.OrderDraft(draftId).totalFillQuantity~=0
                obj.OrderDraft(draftId).histFillQuantity = obj.OrderDraft(draftId).totalFillQuantity;
            else
                obj.OrderDraft(draftId).histFillQuantity = 0;
            end
            obj.OrderDraft(draftId).fillQuantity = 0;
            % ���¶���Busy״̬
            obj.Busy(contractId).(thisAction) = 0;
        case {'BOC','IBOC','BOP','BOL','LMT'}
            % �������δȫ���ɽ�����ʣ������ͬ���Ķ�����������ί��
            %����������ܾ�����ֹͣtimer�����½���ί��
            % �˵ظ�Ϊ��ȡ��ڵ�Error List
            if any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Error_List,'Once')))
                % ֹͣ��ѯ
                if ~any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Sub_Error_List,'Once'))) || ...
                        (any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Sub_Error_List,'Once')))&& obj.OrderDraft(draftId).pollNum > 2)  %����״̬�쳣����3�κ���г���
                    if ~isempty(obj.OrderDraft(draftId).pollTimer)
                        stop(obj.OrderDraft(draftId).pollTimer)
                    end
                    % ---������ѯ״̬---
                    obj.OrderDraft(draftId).status = 'Error_Finished';
                    obj.OrderDraft(draftId).remark = ['��ѯʧ��:',obj.Order(iOrder).statusMsg];
                    %------------------
                    % ���¶���Busy״̬
                    obj.Busy(contractId).(thisAction) = 0;
                end
                %��ʾ
                dispInfo = [' Order ID: ',num2str(orderId),' - OnOrder����״̬�쳣��ԭ�� ',obj.Order(iOrder).statusMsg];
                DispOnOrder(dispInfo,2)
            elseif any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Fill_List,'Once')))
                % ---������ѯ״̬---
                if ~isempty(obj.OrderDraft(draftId).pollTimer)
                    stop(obj.OrderDraft(draftId).pollTimer)
                end
                if obj.OrderDraft(draftId).totalFillQuantity >= obj.OrderDraft(draftId).totalQuantity
                    obj.OrderDraft(draftId).status = 'Finished';
                    obj.OrderDraft(draftId).remark = 'ȫ���ɽ�';
                    obj.OrderDraft(draftId).fillTime = datestr(now,31);
                    %                     disp(['Filled:tradedVolume:',num2str(obj.OrderDraft(draftId).fillQuantity)])
                    % ���¶���Busy״̬
                    obj.Busy(contractId).(thisAction) = 0;
                    % ��ʾ
                    dispInfo = [' Order ID: ',num2str(orderId),' - OnOrderȫ�������ѳɽ���'];
                    %                 DispOnOrder(dispInfo,3)
                    DispOnOrder(dispInfo,3)
                else
                    % ʵ���µ�����С��totalQuantity�������µ����Ѿ�ȫ���ɽ������ת�������һ��ί�У��ɽ��۸���ܻ������⣩
%                     obj.OrderDraft(draftId).status = 'InProgress';
%                     obj.OrderDraft(draftId).remark = '�Ӷ�������ɣ�ִ��ʣ�ඩ��';%�����������һ��ί��
%                     obj.OrderDraft(draftId).histFillQuantity = obj.OrderDraft(draftId).totalFillQuantity;
%                     obj.OrderDraft(draftId).fillQuantity = 0;
%                     obj.Fcn_PlaceOrder(draftId)
                end
            elseif any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Cancel_List,'Once')))
                % ���¶���Busy״̬
                obj.Busy(contractId).(thisAction) = 0;
                % ��תQuantity
                obj.OrderDraft(draftId).histFillQuantity = obj.OrderDraft(draftId).totalFillQuantity;
                obj.OrderDraft(draftId).fillQuantity = 0;
                % ��ʾ
                dispInfo = [' Order ID: ',num2str(orderId),' - OnOrder�ѳ�����'];
                DispOnOrder(dispInfo,4)
                %����ѯ����ָ��״̬ʱ,������ί�У�������������Fcn_PlaceOrder
                StopList = {'��ѯ��������'};
                if ~any(cell2mat(regexp(obj.OrderDraft(draftId).remark,StopList,'Once')))
                    obj.OrderDraft(draftId).status = 'InProgress';
                    obj.OrderDraft(draftId).remark = '�ѳ���';%�����������һ��ί��
                    % ���½���ί��
                    obj.Fcn_PlaceOrder(draftId)
                end
            elseif any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.InProcess_List,'Once')))
                % ��ʾ
                obj.OrderDraft(draftId).status = 'InProgress';
                dispInfo = [' Order ID: ',num2str(orderId),' - OnOrder���������ɹ�,����δ�ɽ�'];
                DispOnOrder(dispInfo,5)
            elseif any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Pending_List,'Once')))
                obj.OrderDraft(draftId).status = 'Pending';
                dispInfo = [' Order ID: ',num2str(orderId),' - OnOrder�������ڷ���...'];
                DispOnOrder(dispInfo,6)
            end
        case 'MTL'
            % �м�ʣ��ת�޼�
        otherwise % �޼۵�
    end
    obj.OrderDraft(draftId).updateTime = datestr(now,'yyyy-mm-dd HH:MM:SS');
    obj.TimeLog.OrderDraft             = datestr(now,'yyyy-mm-dd HH:MM:SS');
catch Err
    disp([datestr(now,'HH:MM:SS'),' CallbackOnOrderChange Error: ',Err.message])
    disp(Err.stack(1))
end
end


function DispOnOrder(dispInfo,number)
%�����ظ���ʾ��Ϣ
%����ʾ����Ϣ���ϴβ�ͬʱ��������ʾ������ֻ��ʾһ��
if nargin <2
    number = 1;
end
persistent dispStr
% dispStr=[];
if isempty(dispStr)
    dispStr = cell(6,1);
end

if isempty(dispStr{number}) || ~strcmpi(dispInfo,dispStr{number})
    disp([datestr(now,'HH:MM:SS'),dispInfo])
    dispStr{number} = dispInfo;
end
end