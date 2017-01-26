classdef BasePriceLadder < handle
    properties
        bidPrice
        askPrice
        bidSize
        askSize
        lastPrice
        lastSize
    end
    
    properties(Hidden)
        Listener
        numLadder
    end
    
    methods
        function obj = BasePriceLadder()
            obj.numLadder = 10;
        end
        
        function ConstructLadder(obj,marketData,minTick)
            % 默认上下各做10个tick
            obj.bidPrice  = nan(obj.numLadder,1);
            obj.askPrice  = nan(obj.numLadder,1);
            obj.bidSize   = nan(obj.numLadder,1);
            obj.askSize   = nan(obj.numLadder,1);
            obj.lastPrice = nan(1,1);
            obj.lastSize  = nan(1,1);
            
            obj.bidPrice(1)  = marketData.bidPrice;
            obj.bidSize(1)   = marketData.bidSize;
            obj.askPrice(1)  = marketData.askPrice;
            obj.askSize(1)   = marketData.askSize;
            obj.lastPrice = marketData.lastPrice;
            obj.lastSize  = marketData.lastSize;
            
            % 根据minTick做出其他的价位
            for i=2:obj.numLadder
                obj.bidPrice(i) = obj.bidPrice(i-1)-minTick;
                obj.askPrice(i) = obj.askPrice(i-1)+minTick;
            end
        end
        
        function data = DispLadder(obj)
            data = cell(obj.numLadder*2+1,5);
            columnname = {'BuyOrderStatus','bidSize','price','askSize','SellOrderStatus'};
            [~,I1] = sort(obj.bidPrice,1,'descend');
            data(obj.numLadder+2:end,2) = num2cell(obj.bidSize(I1));
            data(obj.numLadder+2:end,3) = num2cell(obj.bidPrice(I1));
            [~,I2] = sort(obj.askPrice,1,'descend');
            data(1:obj.numLadder,4) = num2cell(obj.askSize(I2));
            data(1:obj.numLadder,3) = num2cell(obj.askPrice(I2));
            
            data{obj.numLadder+1,3} = obj.lastPrice;
            
            for i=1:size(data,1)
                for j=1:size(data,2)
                    if isnan(data{i,j})
                        data{i,j} = [];
                    end
                end
            end
            uitable('data',data,'columnname',columnname)
        end
    end
    
end