function funOnOrder(obj,varargin)
%IBBUILTINORDERDATAEVENTHANDLER Interactive Brokers' Trader Workstation built in order data event handler.

% Trap event type
switch varargin{end}
    
    case {'openOrderEnd'}
        %         if iOrder >0
        %             obj.Order(iOrder).other.type = varargin{3}.Type;
        %             obj.Order(iOrder).other.eventID = varargin{3}.EventID;
        %         end
        
        %     clear iOrder
        % Return data to base workspace
        %     assignin('base','ibBuiltInOpenOrderData',ibBuiltInOpenOrderData);
        %     clear ibBuiltInOpenOrderData iOrder
        %         evtListeners = varargin{1}.eventlisteners;
        %     i = strcmp(evtListeners(:,1),'openOrderEx');
        %     varargin{1}.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
        %         i = strcmp(evtListeners(:,1),'openOrderEnd');
        %         varargin{1}.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
        %     varargin{end}.DataRequest = false; %#ok
    case {'orderStatus'}  % Order Status Change
        order = varargin{13};
        if varargin{13}.id == 0
            return
        end
        currentPermId = [obj.Order.orderSysId];
        if ~isempty(currentPermId)
            iOrder = find(order.permId == currentPermId);
        else
            iOrder = [];
        end
        if isempty(iOrder) && ~isempty(currentPermId)
            iOrder = length(currentPermId)+1;
        elseif isempty(currentPermId)
            iOrder = 1;
        end
        %以下状态会连续出现7个Push，依次更新
        obj.Order(iOrder,1).statusMsg     = varargin{13}.status;
        obj.Order(iOrder,1).tradedVolume  = varargin{13}.filled;
        obj.Order(iOrder,1).volume        = varargin{13}.filled+varargin{13}.remaining;
        obj.Order(iOrder,1).avgTradePrice = varargin{13}.avgFillPrice;
        %         obj.Order(iOrder,1).orderSysId    = varargin{13}.permId;
        %         obj.Order(iOrder,1).parentId      = varargin{13}.parentId;
        obj.Order(iOrder,1).lastFillPrice = varargin{13}.lastFillPrice;
        obj.Order(iOrder,1).other.clientId= varargin{13}.clientId;
        obj.Order(iOrder,1).other.whyHeld = varargin{13}.whyHeld;
        obj.Order(iOrder,1).updateTime    = datestr(now,31);
        %         if isempty(UpdateCount) || numel(UpdateCount)<iOrder
        %             UpdateCount(iOrder)=1;
        %         else
        %             UpdateCount(iOrder)=UpdateCount(iOrder)+1;
        %         end
        %         if UpdateCount(iOrder)>=6
        %             UpdateCount(iOrder)=0;
        CallbackOnOrderChange(obj,iOrder,varargin)
        %         end
    case {'openOrderEx'}  % Open Order Execution
        orderDetails = get(varargin{7}.order);
        contractDetails = get(varargin{7}.contract);
        orderState = get(varargin{7}.orderState);
        
        currentPermId = [obj.Order.orderSysId];
        if ~isempty(currentPermId)
            iOrder = find(orderDetails.permId == currentPermId);
        else
            iOrder = [];
        end
        if isempty(iOrder) && ~isempty(currentPermId)
            iOrder = length(currentPermId)+1;
        elseif isempty(currentPermId)
            iOrder = 1;
        end
        
        obj.Order(iOrder,1).orderId         = varargin{7}.orderId;
        obj.Order(iOrder,1).localSymbol     = contractDetails.localSymbol;
        obj.Order(iOrder,1).statusMsg       = orderState.status;
        obj.Order(iOrder,1).other.type      = varargin{7}.Type;
        obj.Order(iOrder,1).other.eventID   = varargin{7}.EventID;
        obj.Order(iOrder,1).other.contractDetails =contractDetails;
        obj.Order(iOrder,1).other.orderState = orderState;
        
        Field_orderDetails = fieldnames(orderDetails);
        for i=1:numel(Field_orderDetails)
            switch lower(Field_orderDetails{i})
                case 'orderid'
                    obj.Order(iOrder,1).orderId     = orderDetails.orderId;
                case 'action'
                    if strcmpi(orderDetails.action,'BUY')
                        obj.Order(iOrder,1).isBuy = true;
                    elseif strcmpi(orderDetails.action,'Sell')
                        obj.Order(iOrder,1).isBuy = false;
                    end
                case 'lmtprice'
                    obj.Order(iOrder,1).price = orderDetails.lmtPrice;
                case 'totalquantity'
                    obj.Order(iOrder,1).volume = orderDetails.totalQuantity;
                case 'permid'
                    obj.Order(iOrder,1).orderSysId = orderDetails.permId;
                otherwise
                    obj.Order(iOrder,1).other.(Field_orderDetails{i}) = orderDetails.(Field_orderDetails{i});
            end
        end
        obj.Order(iOrder,1).updateTime    = datestr(now,31);
        CallbackOnOrderChange(obj,iOrder,varargin)
end
end


