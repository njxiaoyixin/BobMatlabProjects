function [listenerId,contractId] = SubscribeMarketData(obj,tradeObjId,varargin)
          % varargin ‰»Î—˘ Ω: 'contractId',contractId
%                             'contractInfo',contractInfo
            if strcmpi(varargin{1},'contractId')
                contractId = varargin{2};
            elseif strcmpi(varargin{1},'contractInfo')
                contractId = obj.DBTrader.AddContract(contractInfo,tradeObjId);
                obj.DBTrader.GetMarketData(tradeObjId)
            end
            listenerId = numel(obj.Listener)+1;
            obj.Listener(listenerId).listenerObj = addlistener(obj.TradeObj{tradeObjId},'MarketData','PostSet',@(src,evnt) SubscribeStrategyMD_CallBack(obj,strategyId,tradeObjId,contractId,src,evnt));
            obj.Listener(listenerId).desc        = ['Subscribe ',obj.DBTrader.TradeObj{tradeObjId}.ContractSet(contractId).localSymbol, ' MarketData from TradeObj ',tradeObjId];
       end