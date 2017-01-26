function GetMarketData(obj,contractId)
            if nargin >= 2  && ~isempty(contractId)%订阅单个合约行情
                if contractId>numel(obj.Contract)
                    warning('No corresponding contract found!')
                    return
                else
                    thisLocalSymbolSet = obj.Contract(contractId).localSymbol;
                end
            else  %订阅所有的合约行情
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
                            =GetMarketData(obj.LoginId,thisLocalSymbolSet{i});%获取一个合约当前最新行情数据。
                        SubscribeMD(obj.LoginId, thisLocalSymbolSet{i});
                    end
                else
%                     obj.MarketData(contractId) = BaseMarketData;
                    [obj.MarketData(contractId,1).preClose,obj.MarketData(contractId,1).preSettlementPrice ,obj.MarketData(contractId,1).openPrice , obj.MarketData(contractId,1).lastPrice , obj.MarketData(contractId,1).bidPrice , obj.MarketData(contractId,1).askPrice, obj.MarketData(contractId,1).bidSize ,obj.MarketData(contractId,1).askSize ,obj.MarketData(contractId,1).highestPrice, obj.MarketData(contractId,1).lowestPrice, obj.MarketData(contractId,1).volume, obj.MarketData(contractId,1).amount] ...
                        =GetMarketData(obj.LoginId,thisLocalSymbolSet);%获取一个合约当前最新行情数据。
                    SubscribeMD(obj.LoginId, thisLocalSymbolSet);
                end
                
%                 obj.LoginId.registerevent({'OnMarketData' @(varargin) obj.funOnMarketData(varargin{:})});
                disp([datestr(now,'HH:MM:SS'),'---CTP Market Data Subscription Succeeded.---'])
            catch Err
                disp(Err.message)
            end
        end