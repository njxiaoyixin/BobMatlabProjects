function Clear(obj,orderInfo)
if ischar(orderInfo)%�������localSymbol
    thisOrderInfo.localSymbol = orderInfo;
    orderInfo = thisOrderInfo;
end
localSymbol = orderInfo.localSymbol;
%���ָ��ͷ��
if obj.SystemSwitch.isTrade>0 && ~isempty(obj.Position)
    currentLocalSymbol = {obj.Position.localSymbol};
    iSet = find(strcmpi(currentLocalSymbol,localSymbol));
    if isempty(iSet)
        dispInfo = ['---',localSymbol,' ��ղ�λ������,���ʧ��.---'];
        DispOnClear(dispInfo,1)
        return
    end
    for i = 1:numel(iSet)
        if  obj.Position(iSet(i)).volume<=0 && obj.Position(iSet(i)).isLong<=0
%             dispInfo = ['---',localSymbol,' ��ͷ��λ������,���ʧ��.---'];
%             DispOnClear(dispInfo,2)
            continue
        elseif obj.Position(iSet(i)).volume<=0 && obj.Position(iSet(i)).isLong>0
%             dispInfo = ['---',localSymbol,' ��ͷ��λ������,���ʧ��.---'];
%             DispOnClear(dispInfo,3)
            continue
        end
        disp([datestr(now,'HH:MM:SS'),'---��ʼ���',localSymbol,'...---'])
        % ���û�м��뵽��ƷContract�У���û��MarketData����ƽ��
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
            pause(2)%�ȴ�����
        end
        % ����Ʒ�ֵ�Open Orderȫ��Cancel
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
            %MarketData��Ȼ�޷�ȡ�ã��˳�
            disp([datestr(now,'HH:MM:SS'),' Clear Error: Market Data for ',localSymbol,'Cannot be Retrived!'])
            return
        end
        
        if obj.Position(iSet(i)).isLong > 0  %��ͷͷ��
            Order1.action        = 'Sell';
            Order1.totalQuantity = obj.Position(iSet(i)).volume;
            Order1.lmtPrice      = obj.MarketData(contractId).bidPrice;
            Order1.orderStrategy = 'IBOC';
            TradeParam.TasksToExecute = 20;
            draftId = obj.AddOrder(contractId,Order1,TradeParam);
            obj.TransmitOrder(draftId);
        elseif obj.Position(iSet(i)).isLong <= 0  %��ͷͷ��
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
%�����ظ���ʾ��Ϣ
%����ʾ����Ϣ���ϴβ�ͬʱ��������ʾ������ֻ��ʾһ��
persistent dispStr
if isempty(dispStr)
    dispStr = cell(3,1);
end
if isempty(dispStr{number}) || ~strcmpi(dispInfo,dispStr{number})
    disp([datestr(now,'HH:MM:SS'),dispInfo])
    dispStr{number} = dispInfo;
end
end
