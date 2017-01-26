function CallbackOnOrderChange(obj,iOrder,varargin)
% CTP对draftId的查找开销0.002,对quantity的更新开销0.006,对OrderDraft状态更新的时间0.004
% IB对draftId的查找开销0.0006,对quantity的更新开销0.02,对OrderDraft状态更新的时间0.02
try
    % 如果OrderDraft未进行设置，则返回
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
    
    %当orderId囊括了所有的orderId时
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
    
    %当只跟踪一个orderId时
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
            % 下单成功后直接撤单（部分成交或全不成交及撤单）
            obj.CancelOrder(obj.OrderDraft(draftId).orderId);
            %更新轮询状态
            obj.OrderDraft(draftId).status = 'Finished';%有问题
            obj.OrderDraft(draftId).remark = '全部成交';%有问题
            %结转Hist
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
            % 更新订单Busy状态
            obj.Busy(contractId).(thisAction) = 0;
        case {'BOC','IBOC','BOP','BOL','LMT'}
            % 如果订单未全部成交，则将剩余量以同样的订单参数进行委托
            %如果报单被拒绝，则停止timer不重新进行委托
            % 此地改为读取借口的Error List
            if any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Error_List,'Once')))
                % 停止轮询
                if ~any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Sub_Error_List,'Once'))) || ...
                        (any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Sub_Error_List,'Once')))&& obj.OrderDraft(draftId).pollNum > 2)  %允许状态异常发生3次后进行撤单
                    if ~isempty(obj.OrderDraft(draftId).pollTimer)
                        stop(obj.OrderDraft(draftId).pollTimer)
                    end
                    % ---更新轮询状态---
                    obj.OrderDraft(draftId).status = 'Error_Finished';
                    obj.OrderDraft(draftId).remark = ['轮询失败:',obj.Order(iOrder).statusMsg];
                    %------------------
                    % 更新订单Busy状态
                    obj.Busy(contractId).(thisAction) = 0;
                end
                %显示
                dispInfo = [' Order ID: ',num2str(orderId),' - OnOrder订单状态异常，原因： ',obj.Order(iOrder).statusMsg];
                DispOnOrder(dispInfo,2)
            elseif any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Fill_List,'Once')))
                % ---更新轮询状态---
                if ~isempty(obj.OrderDraft(draftId).pollTimer)
                    stop(obj.OrderDraft(draftId).pollTimer)
                end
                if obj.OrderDraft(draftId).totalFillQuantity >= obj.OrderDraft(draftId).totalQuantity
                    obj.OrderDraft(draftId).status = 'Finished';
                    obj.OrderDraft(draftId).remark = '全部成交';
                    obj.OrderDraft(draftId).fillTime = datestr(now,31);
                    %                     disp(['Filled:tradedVolume:',num2str(obj.OrderDraft(draftId).fillQuantity)])
                    % 更新订单Busy状态
                    obj.Busy(contractId).(thisAction) = 0;
                    % 显示
                    dispInfo = [' Order ID: ',num2str(orderId),' - OnOrder全部报单已成交！'];
                    %                 DispOnOrder(dispInfo,3)
                    DispOnOrder(dispInfo,3)
                else
                    % 实际下单数量小于totalQuantity，但是下单后已经全部成交，则结转后进行下一轮委托（成交价格可能会有问题）
%                     obj.OrderDraft(draftId).status = 'InProgress';
%                     obj.OrderDraft(draftId).remark = '子订单已完成，执行剩余订单';%撤单后进行下一轮委托
%                     obj.OrderDraft(draftId).histFillQuantity = obj.OrderDraft(draftId).totalFillQuantity;
%                     obj.OrderDraft(draftId).fillQuantity = 0;
%                     obj.Fcn_PlaceOrder(draftId)
                end
            elseif any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Cancel_List,'Once')))
                % 更新订单Busy状态
                obj.Busy(contractId).(thisAction) = 0;
                % 结转Quantity
                obj.OrderDraft(draftId).histFillQuantity = obj.OrderDraft(draftId).totalFillQuantity;
                obj.OrderDraft(draftId).fillQuantity = 0;
                % 显示
                dispInfo = [' Order ID: ',num2str(orderId),' - OnOrder已撤单！'];
                DispOnOrder(dispInfo,4)
                %当轮询发生指定状态时,不重新委托，否则重新运行Fcn_PlaceOrder
                StopList = {'轮询次数到达'};
                if ~any(cell2mat(regexp(obj.OrderDraft(draftId).remark,StopList,'Once')))
                    obj.OrderDraft(draftId).status = 'InProgress';
                    obj.OrderDraft(draftId).remark = '已撤单';%撤单后进行下一轮委托
                    % 重新进行委托
                    obj.Fcn_PlaceOrder(draftId)
                end
            elseif any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.InProcess_List,'Once')))
                % 显示
                obj.OrderDraft(draftId).status = 'InProgress';
                dispInfo = [' Order ID: ',num2str(orderId),' - OnOrder订单发出成功,订单未成交'];
                DispOnOrder(dispInfo,5)
            elseif any(cell2mat(regexpi(obj.Order(iOrder).statusMsg,obj.Pending_List,'Once')))
                obj.OrderDraft(draftId).status = 'Pending';
                dispInfo = [' Order ID: ',num2str(orderId),' - OnOrder订单正在发送...'];
                DispOnOrder(dispInfo,6)
            end
        case 'MTL'
            % 市价剩余转限价
        otherwise % 限价单
    end
    obj.OrderDraft(draftId).updateTime = datestr(now,'yyyy-mm-dd HH:MM:SS');
    obj.TimeLog.OrderDraft             = datestr(now,'yyyy-mm-dd HH:MM:SS');
catch Err
    disp([datestr(now,'HH:MM:SS'),' CallbackOnOrderChange Error: ',Err.message])
    disp(Err.stack(1))
end
end


function DispOnOrder(dispInfo,number)
%避免重复显示信息
%当显示的信息与上次不同时，进行显示，否则只显示一遍
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