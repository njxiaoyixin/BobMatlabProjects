classdef BaseBasket < handle
    properties(SetAccess = private)
        createTime           %创建时间
        accountObjId
        quoteObjId
    end
    properties
        name
        basketContract@BaseBasketContract
        marketValue
    end
    methods
        function obj = BaseBasket()
            obj.createTime = datestr(now,31);
        end
        
        function isOK = SelfCheck(obj)
            isOK = 1;
            for i=1:numel(obj.basketContract)
                if ~obj.basketContract(i).SelfCheck
                    isOK = 0;
                    break
                end
            end
        end
    end
end