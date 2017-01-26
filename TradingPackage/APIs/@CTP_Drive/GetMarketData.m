function GetMarketData(obj,contractId)
            if nargin >= 2  && ~isempty(contractId)%���ĵ�����Լ����
                if contractId>numel(obj.Contract)
                    warning('No corresponding contract found!')
                    return
                else
                    thisLocalSymbolSet = obj.Contract(contractId).localSymbol;
                end
            else  %�������еĺ�Լ����
                if numel(obj.Contract) >0
                    %                     thisLocalSymbolSet = cell(1,numel(obj.Contract));
                    %                     for i=1:numel(obj.Contract)
                    %                         thisLocalSymbolSet{i} = obj.Contract(i).localSymbol;
                    %                     end
                    thisLocalSymbolSet = {obj.Contract.localSymbol};
                else
                    warning([datestr(now,'HH:MM:SS'),'No contract set!'])
                    return
                end
            end
            try
                if ~obj.SystemSwitch.InitFinished
                    disp([datestr(now,'HH:MM:SS'),'---Market Data Source Not Connected! Market Data Subscription Canceled.---'])
                    return
                end
                if iscell(thisLocalSymbolSet)
                    for i=1:numel(thisLocalSymbolSet)
                        contractId = i;
%                         obj.MarketData(contractId) = BaseMarketData;
                        [obj.MarketData(contractId,1).preClose,obj.MarketData(contractId,1).preSettlementPrice ,obj.MarketData(contractId,1).openPrice , obj.MarketData(contractId,1).lastPrice , obj.MarketData(contractId,1).bidPrice , obj.MarketData(contractId,1).askPrice, obj.MarketData(contractId,1).bidSize ,obj.MarketData(contractId,1).askSize ,obj.MarketData(contractId,1).highestPrice, obj.MarketData(contractId,1).lowestPrice, obj.MarketData(contractId,1).volume, obj.MarketData(contractId,1).amount] ...
                            =GetMarketData(obj.LoginId,thisLocalSymbolSet{i});%��ȡһ����Լ��ǰ�����������ݡ�
                        SubscribeMD(obj.LoginId, thisLocalSymbolSet{i});
                    end
                else
%                     obj.MarketData(contractId) = BaseMarketData;
                    [obj.MarketData(contractId,1).preClose,obj.MarketData(contractId,1).preSettlementPrice ,obj.MarketData(contractId,1).openPrice , obj.MarketData(contractId,1).lastPrice , obj.MarketData(contractId,1).bidPrice , obj.MarketData(contractId,1).askPrice, obj.MarketData(contractId,1).bidSize ,obj.MarketData(contractId,1).askSize ,obj.MarketData(contractId,1).highestPrice, obj.MarketData(contractId,1).lowestPrice, obj.MarketData(contractId,1).volume, obj.MarketData(contractId,1).amount] ...
                        =GetMarketData(obj.LoginId,thisLocalSymbolSet);%��ȡһ����Լ��ǰ�����������ݡ�
                    SubscribeMD(obj.LoginId, thisLocalSymbolSet);
                end
                
%                 obj.LoginId.registerevent({'OnMarketData' @(varargin) obj.funOnMarketData(varargin{:})});
                disp([datestr(now,'HH:MM:SS'),'---CTP Market Data Subscription Succeeded.---'])
            catch Err
                disp(Err.message)
            end
        end