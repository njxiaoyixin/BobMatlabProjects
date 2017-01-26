function Fcn_PlaceOrder(obj,draftId,varargin)
% 用于进行轮询下单的回调函数,轮询的参数在Transmit当中设置好,存储在OrderDraft的orderInfo中

% ********** 1. 轮询判断模块**********
if obj.OrderDraft(draftId,1).busy
    return
end
obj.OrderDraft(draftId,1).busy              = 1;
try
    % 以下3种情况需要停止轮询
    % 1. 当OrderDraft当中的totalQuantity已经全部成交(成交回报通过OnOrder进行更新)
    % 2. 当轮询次数到达上限时,进行撤单操作
    % 3. 当外部执行了CancelOrder时，根据Param中的CancelAtEnd参数进行撤单操作，并停止轮询
    % 4. 当1,2和3都不满足时,尝试进行撤单；当未成交的Order无法进行撤单时,此时订单可能已经全部成交或订单未成功发送
    
    obj.OrderDraft(draftId)  = obj.OrderDraft(draftId);
    thisAction = [upper(obj.OrderDraft(draftId).orderInfo.action(1)),lower(obj.OrderDraft(draftId).orderInfo.action(2:end))];
    thisOrderStrategy = upper(obj.OrderDraft(draftId).orderInfo.orderStrategy);
    if any(strcmpi(obj.OrderDraft(draftId).status,{'Finished','Error_Finished'}))
        if ~isempty(obj.OrderDraft(draftId).pollTimer)
            stop(obj.OrderDraft(draftId).pollTimer)
        end
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 订单状态已结束!'])
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
        return
    end
    % 如果已经全部成交，则停止轮询
    if obj.OrderDraft(draftId).totalFillQuantity>=obj.OrderDraft(draftId).orderInfo.totalQuantity
        % 停止轮询
        if ~isempty(obj.OrderDraft(draftId).pollTimer)
            stop(obj.OrderDraft(draftId).pollTimer)
        end
        obj.OrderDraft(draftId).status = 'Finished';
        obj.OrderDraft(draftId).remark = '全部成交';
        %更新Busy状态
        obj.Busy(obj.OrderDraft(draftId).contractId).(thisAction) = 0;
        %显示
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 全部订单已成交,轮询结束!'])
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
        return
    end
    % 如果轮询次数到达,则停止轮询
    if obj.OrderDraft(draftId).pollNum >= obj.OrderDraft(draftId).param.PollNum
        %停止轮询
        if ~isempty(obj.OrderDraft(draftId).pollTimer)
            stop(obj.OrderDraft(draftId).pollTimer)
        end
        obj.OrderDraft(draftId).status = 'Finished';
        obj.OrderDraft(draftId).remark = '轮询次数到达,状态已定';  % 在funOnOrder中，看见此标志，不重新运行Fcn_PlaceOrder
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 轮询次数到达,状态已定！'])
        if obj.OrderDraft(draftId).param.CancelAtEnd
            obj.CancelOrder(obj.OrderDraft(draftId).orderId);
            obj.OrderDraft(draftId).remark = '轮询次数到达,单状态未定';  % 在funOnOrder中，看见此标志，不重新运行Fcn_PlaceOrder
        end
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
        return
    end
    %如果执行了CancelDraftOrder，则撤单，并停止轮询
    if strcmpi(obj.OrderDraft(draftId).remark,'已停止')
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 轮询轮询已手动停止！'])
        return
    end
    %如果撤单次数已经到达上限，则停止轮询
    if obj.OrderDraft(draftId).cancelNum >= obj.OrderDraft(draftId).param.CancelNum
        %停止轮询
        if ~isempty(obj.OrderDraft(draftId).pollTimer)
            stop(obj.OrderDraft(draftId).pollTimer)
        end
        obj.OrderDraft(draftId).status = 'Error_Finished';
        obj.OrderDraft(draftId).remark = '最大尝试撤单次数到达';  % 在funOnOrder中，看见此标志，不重新运行Fcn_PlaceOrder
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 最大尝试撤单次数到达！'])
        obj.OrderDraft(draftId,1).busy = 0;
        obj.TimeLog.OrderDraft = datestr(now,31);
        return
    end
    % 撤单并重新委托
    if obj.OrderDraft(draftId).pollNum>=1
        if obj.OrderDraft(draftId).totalFillQuantity >0
            obj.OrderDraft(draftId).status = 'InProgress';
            %             obj.OrderDraft(draftId).remark = '部分成交';
        end
        % 判断应该继续下单，还是应该撤掉上个轮询未成交的订单
        %         isOpen = IsOrderOpen(obj.LoginId,obj.OrderDraft(draftId).orderId);
        %         if isOpen  % IsOrderOpen命令容易Bug
        if any(strcmpi(obj.OrderDraft(draftId).status,{'InProgress','Error_InProgress'})) && ~strcmpi(obj.OrderDraft(draftId).remark,'已撤单')
            %如果当前有活跃的订单，则撤单，然后跳出Fcn_PlaceOrder，待funOnOrder返回撤单结果后继续下单
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
            %                 % 更新轮询状态
            %                 obj.OrderDraft(draftId).status = 'Error_InProgress';
            %                 obj.OrderDraft(draftId).remark = '撤单失败';
            %                 %更新Busy状态
            %                 %                 obj.Busy(obj.lOrderDraft(draftId).contractId).(thisAction) = 0;
            %                 %显示
            %                 disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 轮询撤单失败'])
            %                 obj.OrderDraft(draftId,1).busy = 0;
            %                 obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
            %                 return
            %             else
            obj.OrderDraft(draftId).status = 'InProgress';
            obj.OrderDraft(draftId).remark = '撤单命令已发出';
            disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 撤单命令已发出,等待OnOrder撤单回报'])
            obj.OrderDraft(draftId,1).busy = 0;
            obj.TimeLog.OrderDraft = datestr(now,'yyyy-mm-dd HH:MM:SS');
            return
            %             end
        elseif any(strcmpi(obj.OrderDraft(draftId).status,{'InProgress','Error_InProgress'}))
            %注：当Pending的时候代表订单未发出或成交回报未获得，不要往后继续下单
            %继续往后进行下单
        else
            switch obj.OrderDraft(draftId).status
                case 'Pending'
                    disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 订单未发送成功或成交回报未返回，暂不下单'])
                otherwise
                    disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 不支持下单的Status:',obj.OrderDraft(draftId).status])
            end
            return
        end
    else
        %首次轮询，继续往后进行下单
    end
catch Err
    disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 停止轮询判断失败,失败原因：',Err.message,',行数：',num2str(Err.stack(1).line)])
end

%% ********* 2. 实时行情判断模块 **********
obj.OrderDraft(draftId).pollNum   = obj.OrderDraft(draftId).pollNum+1;  %增加轮询次数
obj.OrderDraft(draftId).cancelNum = 0;%清空撤单次数
% 放在这里是因为本段有一个Return，发生本段的情况也应该算一次轮询
if ~strcmpi(thisOrderStrategy,'LMT')  %限价单不用判断行情
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
            %         %如果行情为0，则跳出函数
            %         if ~isempty(obj.OrderDraft(draftId).pollTimer)
            %             stop(obj.OrderDraft(draftId).pollTimer)
            %         end
            %  更新轮询状态
            obj.OrderDraft(draftId).status = 'Error_InProgress';
            obj.OrderDraft(draftId).remark = '价格为零,无法交易';
            %更新Busy状态
            obj.Busy(obj.OrderDraft(draftId).contractId).(thisAction) = 0;
            disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 轮询失败,',obj.Contract(obj.OrderDraft(draftId).contractId).localSymbol,obj.OrderDraft(draftId).remark])
            obj.OrderDraft(draftId,1).busy = 0;
            return
        end
    catch Err
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 实时行情判断模块出错,错误原因：',Err.message])
        obj.OrderDraft(draftId,1).busy = 0;
        return
    end
end
%% ********** 3.订单参数设置模块 **********
thisQuantity = obj.OrderDraft(draftId).orderInfo.totalQuantity-obj.OrderDraft(draftId).totalFillQuantity;
if isempty(obj.OrderDraft(draftId).param.MinTick) || obj.OrderDraft(draftId).param.MinTick==0
    Param.TickSize   = obj.Contract(obj.OrderDraft(draftId).contractId).minTick; %每个tick的大小
end
if isempty(Param.TickSize) || Param.TickSize<=0
    Param.TickSize=0;
end
Param.PriceShift = obj.OrderDraft(draftId).param.PriceShift; %往对方盘口偏移的Tick数量，正数代表往对方盘口便宜，负数代表往本方盘口便宜

switch upper(thisOrderStrategy)
    % 针对不同的订单类型,设置不同的限价价格及限价量
    case 'FOK'
        % 检测现在盘口是否有足够订单,如果没有则撤单(因为只能看到一档行情,所以只判断一档的量)
        if any(strcmpi(thisAction,{'BUY','COVER'}))
            if obj.OrderDraft(draftId).orderInfo.lmtPrice >=obj.MarketData(idx).askPrice  && obj.OrderDraft(draftId).orderInfo.totalQuantity >= obj.MarketData(idx).AskSize
                thisPrice = obj.MarketData(idx).askPrice+Param.TickSize*Param.PriceShift;
            else % 量不足,直接撤单
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
        % 下单成功后直接撤单（部分成交或全不成交及撤单）（在onOrder中撤单）
        thisPrice = obj.OrderDraft(draftId).orderInfo.lmtPrice;
    case {'BOC','IBOC'}
        % 在一档的对手价进行下单,IBOC订单为轮询时间更短的BOC订单
        switch upper(thisAction)
            case {'BUY','COVER'}
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice-Param.TickSize*Param.PriceShift;
        end
    case 'BOP'
        % 在本方盘口价进行下单
        switch upper(thisAction)
            case {'BUY','COVER'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice-Param.TickSize*Param.PriceShift;
        end
    case 'BOL'
        % 以最新价进行下单
        switch upper(thisAction)
            case {'BUY','COVER'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).lastPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).lastPrice-Param.TickSize*Param.PriceShift;
        end
    case 'BOV'
        % 第一次以本方盘口下单，第二次以最新价下单，第三次以对方盘口下单
        switch upper(thisAction)
            case {'BUY','COVER'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).lastPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice;
                thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).lastPrice-Param.TickSize*Param.PriceShift;
        end
    otherwise % 限价单
        switch upper(thisAction)
            case {'BUY','COVER'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).bidPrice;
                thisPrice = obj.OrderDraft(draftId).orderInfo.lmtPrice+Param.TickSize*Param.PriceShift;
            case {'SELL','SHORT'}
                %                 thisPrice = obj.MarketData(obj.OrderDraft(draftId).contractId).askPrice;
                thisPrice = obj.OrderDraft(draftId).orderInfo.lmtPrice-Param.TickSize*Param.PriceShift;
        end
end
%% ********** 4. 下单模块 **********
try
    if thisPrice > 10e7 || thisPrice <= 0.01 %去除异常价格
        disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 订单价格',num2str(thisPrice),'超过10e7,订单异常,Dump!'])
        orderId = -1;
    elseif strcmpi(thisOrderStrategy,'FOK') && thisPrice <0 %FOK单如果已经撤单
        orderId = -1;
        disp([datestr(now,'HH:MM:SS'),' Order ID: ',num2str(orderId),' - ',obj.OrderDraft(draftId).localSymbol,' ',obj.OrderDraft(draftId).orderInfo.thisOrderStrategy,'-',thisAction,'报单,','报单价格：',num2str(obj.OrderDraft(draftId).orderInfo.lmtPrice),',数量：',num2str(thisQuantity),',轮询次数',num2str(obj.OrderDraft(draftId).pollNum+1)]);
        disp([datestr(now,'HH:MM:SS'),' FOK订单盘口量不足,已撤单!'])
    else
        OrderInfo.Contract  = obj.Contract(obj.OrderDraft(draftId).contractId);
        OrderInfo.action    = thisAction;
        OrderInfo.quantity  = thisQuantity;
        OrderInfo.price     = thisPrice;
        OrderInfo.orderType = obj.OrderDraft(draftId).orderType;
        orderId = obj.BaseTransmit(OrderInfo);
        disp([datestr(now,'HH:MM:SS'),' Order ID: ',num2str(orderId),' - ',obj.OrderDraft(draftId).localSymbol,' ',thisOrderStrategy,'-',thisAction,'报单, 报单价格: ',num2str(thisPrice),', 数量: ',num2str(thisQuantity),', 轮询次数: ',num2str(obj.OrderDraft(draftId).pollNum)]);
    end
catch Err
    disp([datestr(now,'HH:MM:SS'),' Fcn_PlaceOrder - 下单模块异常,异常原因:',Err.message,', 异常行数:',num2str(Err.stack(1).line)])
    obj.OrderDraft(draftId,1).busy = 0;
    return
end
%% ********** 5. 报单情况总结 **********
if orderId > 0 || (strcmpi(thisOrderStrategy,'FOK') && thisPrice <0)
    obj.OrderDraft(draftId).status = 'Pending';
    obj.OrderDraft(draftId).remark = '轮询中';
    disp([datestr(now,'HH:MM:SS'),' Order ID: ',num2str(orderId),' - 报单成功.等待成交回报...'])
    % 更新订单Busy状态
    obj.Busy(obj.OrderDraft(draftId).contractId).(thisAction) = 1;
else
    obj.OrderDraft(draftId).status = 'Error_Finished';
    obj.OrderDraft(draftId).remark = '轮询失败: 下单失败';
    disp([datestr(now,'HH:MM:SS'),' Order ID: ',num2str(orderId),' - 报单失败. 停止轮询.'])
    % 报单失败后停止轮询
    if ~isempty(obj.OrderDraft(draftId).pollTimer)
        stop(obj.OrderDraft(draftId).pollTimer)
    end
    obj.Busy(obj.OrderDraft(draftId).contractId).(thisAction) = 0;
end
%更新数据
obj.OrderDraft(draftId).orderId    = orderId;
obj.OrderDraft(draftId).allOrderId(1,end+1) = orderId;
obj.OrderDraft(draftId,1).busy = 0;
end
