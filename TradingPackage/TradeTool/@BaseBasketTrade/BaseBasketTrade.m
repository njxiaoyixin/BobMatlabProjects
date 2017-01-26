classdef BaseBasketTrade < BaseStrategy
    properties(SetAccess = private)
        createTime
        id
        config
        totalMarketValue
        filledMarketValue
        impactCost
        status
    end
    
    properties
        basket @BaseBasket
    end
    
    methods
        function obj = BaseBasketTrade()
            
        end
        
        function ReadConfig(obj)
            % ¶ÁÈ¡ÅäÖÃÎÄ¼ş
            % Initialization
            File = 'BasketConfig.ini';
            I = INI('File',File);
            % INI file reading
            I.read();
            obj.config = I;
        end
        
        function ConnectTrade(obj)
            for i=1:numel(obj.basket)
                if strcmpi(obj.status(i),'Finished')
                    continue
                end
                for j=1:numel(obj.basket(i).basketContract)
                    accountAlias = obj.basket(i).basketContract.account;
                    quoteAlias   = obj.basket(i).basketContract.quote;
                    thisAccount  = obj.config.accounts.(accountAlias);
                    thisQuote    = obj.config.accounts.(quoteAlias);
                    
                    tradeObjId1=obj.DBTrader.AddTradeObj(obj,obj.config.(thisAccount).Type,accountAlias);
                    obj.basket(i).accountObjId = tradeObjId1;
                    obj.DBTrader.PresetLoginParam(tradeObjId1,obj.config.(thisAccount));
                    obj.DBTrader.LoginTradeObj(tradeObjId1)
                    
                    tradeObjId2=obj.DBTrader.AddTradeObj(obj,obj.config.(thisQuote).Type,quoteAlias);
                    obj.basket(i).quoteObjId = tradeObjId2;
                    obj.DBTrader.PresetLoginParam(tradeObjId2,obj.config.(thisQuote));
                    obj.DBTrader.LoginTradeObj(tradeObjId2)
                    
                    % Addcontract
                    
                    % Duplicate Quote
                    
                end
            end
        end
        
        function basketId = AddBasket(obj,Basket)
            basketId = numel(obj.Basket)+1;
            if Basket.SelfCheck
                obj.Basket(basketId) = Basket;
            end
        end
        
        function TradeBasket(obj,basketId)
            % Add Contract to MarketData Source and TradeSource
            
            % Subscribe MarketData
            
        end
    end
    
    methods %callbacks
        
    end
end