function Clear(obj,orderInfo)
if ischar(orderInfo)%输入的是localSymbol
    thisOrderInfo.localSymbol = orderInfo;
    orderInfo = thisOrderInfo;
end
localSymbol = orderInfo.localSymbol;
%清空指定头寸
if obj.SystemSwitch.isTrade>0 && ~isempty(obj.Position)
    currentLocalSymbol = {obj.Position.localSymbol};
    iSet = find(strcmpi(currentLocalSymbol,localSymbol));
    if isempty(iSet)
        dispInfo = ['---',localSymbol,' 多空仓位不存在,清仓失败.---'];
        DispOnClear(dispInfo,1)
        return
    end
    for i = 1:numel(iSet)
        if  obj.Position(iSet(i)).volume<=0 && obj.Position(iSet(i)).isLong<=0
%             dispInfo = ['---',localSymbol,' 空头仓位不存在,清仓失败.---'];
%             DispOnClear(dispInfo,2)
            continue
        elseif obj.Position(iSet(i)).volume<=0 && obj.Position(iSet(i)).isLong>0
%             dispInfo = ['---',localSymbol,' 多头仓位不存在,清仓失败.---'];
%             DispOnClear(dispInfo,3)
            continue
        end
        disp([datestr(now,'HH:MM:SS'),'---开始清仓',localSymbol,'...---'])
        % 如果没有加入到产品Contract中，则没有MarketData，不平仓
        currentLocalSymbol = arrayfun(@(x) obj.Contract(x).localSymbol,1:numel(obj.Contract),'UniformOutput',false);
        contractId = find(strcmpi(currentLocalSymbol,obj.Position(iSet(i),1).localSymbol),1);
        if isempty(contractId)
            disp([datestr(now,'HH:MM:SS'),'---Market Data not subscribed. Adding New...---'])
            %                 return
            contractId = obj.AddContract(orderInfo);
%             obj.GetMarketData(contractId);
        end
        if isempty(obj.MarketData) || numel(obj.MarketData) < contractId ||isempty(obj.MarketData(contractId))
            obj.GetMarketData(contractId);
            pause(2)%等待行情
        end
        % 将该品种的Open Order全部Cancel
        if ~isempty(obj.Order)
            currentOrderId = [obj.Order.orderId];
            currentOrderlocalSymbol = {obj.Order.localSymbol};
            if ~isempty(currentOrderId)
                for k=1:numel(currentOrderId)
                    if strcmpi(localSymbol,currentOrderlocalSymbol{k})
                        cancelId = CancelOrder(obj,currentOrderId(k));
                    end
                end
            end
        end
        
        if isempty(obj.MarketData(contractId))
            %MarketData仍然无法取得，退出
            disp([datestr(now,'HH:MM:SS'),' Clear Error: Market Data for ',localSymbol,'Cannot be Retrived!'])
            return
        end
        
        if obj.Position(iSet(i)).isLong > 0  %多头头寸
            Order1.action        = 'Sell';
            Order1.totalQuantity = obj.Position(iSet(i)).volume;
            Order1.lmtPrice      = obj.MarketData(contractId).bidPrice;
            Order1.orderStrategy = 'IBOC';
            TradeParam.TasksToExecute = 20;
            draftId = obj.AddOrder(contractId,Order1,TradeParam);
            obj.TransmitOrder(draftId);
        elseif obj.Position(iSet(i)).isLong <= 0  %空头头寸
            Order1.action        = 'Cover';
            Order1.totalQuantity = obj.Position(iSet(i)).volume;
            Order1.lmtPrice      = obj.MarketData(contractId).askPrice;
            Order1.orderStrategy = 'IBOC';
            TradeParam.TasksToExecute = 20;
            draftId = obj.AddOrder(contractId,Order1,TradeParam);
            obj.TransmitOrder(draftId);
        end
    end
end
end

function DispOnClear(dispInfo,number)
if nargin < 2
    number =1;
end
%避免重复显示信息
%当显示的信息与上次不同时，进行显示，否则只显示一遍
persistent dispStr
if isempty(dispStr)
    dispStr = cell(3,1);
end
if isempty(dispStr{number}) || ~strcmpi(dispInfo,dispStr{number})
    disp([datestr(now,'HH:MM:SS'),dispInfo])
    dispStr{number} = dispInfo;
end
end
