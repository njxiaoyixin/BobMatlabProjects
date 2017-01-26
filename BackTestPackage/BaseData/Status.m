classdef Status<handle
    properties
        Multiplier
        Position
        BuildTime
        OpenPrice
        RealizedGain
        RealizedRet
        UnrealizedGain
        UnrealizedRet
        UnrealizedPosRet  %Unrealized Ret based on market value of the opening position
        InitialFund
        ExtraFund
        Fund
    end
    methods
        function obj=Status(TheInitialFund)
            obj.InitialFund=TheInitialFund;
            obj.Fund=TheInitialFund;
            obj.ExtraFund=0;
            obj.BuildTime=0;
            obj.OpenPrice=0;
            obj.RealizedGain=0;
            obj.RealizedRet=0;
            obj.UnrealizedGain=0;
            obj.UnrealizedRet=0;
            obj.UnrealizedPosRet = 0;
            obj.Position=0;
        end
        
        function buy(obj,time,price,quantity)
            if isnan(price)
                error('Shit! The price is nan!')
            end
            obj.BuildTime=time;
            obj.OpenPrice=(obj.OpenPrice*obj.Position+price*quantity)/(obj.Position+quantity);
            obj.Position=obj.Position+quantity;
        end
        
        function sell(obj,time,price,quantity)
            obj.BuildTime=time;
            obj.OpenPrice=(obj.OpenPrice*obj.Position+price*(-quantity))/(obj.Position-quantity);
            obj.Position=obj.Position-quantity;
        end
        
        function closeshort(obj,~,~,quantity)
            obj.Position=obj.Position+quantity;
        end
        
        function closelong(obj,~,~,quantity)
            obj.Position=obj.Position-quantity;
        end
        
        function RefreshUnrealized(obj,price)
            %           if obj.Position>0
            %              obj.UnrealizedRet=log(price/obj.OpenPrice);
            %           elseif obj.Position<0
            %               obj.UnrealizedRet=-log(price/obj.OpenPrice);
            %           else
            %               obj.UnrealizedRet=0;
            %           end
            if isnan(price)
                error('Shit! The price is nan!')
            end
            obj.UnrealizedGain   = (price-obj.OpenPrice)*obj.GetPosition()*obj.Multiplier;
            obj.UnrealizedRet    = obj.UnrealizedGain/obj.Fund;
            if obj.Position~=0
                obj.UnrealizedPosRet = obj.UnrealizedGain/(obj.OpenPrice*obj.Multiplier*abs(obj.Position));
            else
                obj.UnrealizedPosRet = 0;
            end
        end
        
        function RefreshRealized(obj,thisRet,thisGain)
            obj.RealizedGain=obj.RealizedGain+thisGain;
            obj.RealizedRet=obj.RealizedRet+thisRet;
            obj.Fund=obj.Fund+thisGain;
        end
        
        function p=GetPosition(obj)
            p=obj.Position;
        end
        
        function ChangeFund(obj,AddedFund)
            obj.ExtraFund=obj.ExtraFund+AddedFund;
            obj.Fund=obj.Fund+AddedFund;
        end
    end
end