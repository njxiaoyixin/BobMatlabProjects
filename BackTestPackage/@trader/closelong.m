function closelong(obj,time,price,quantity,i)
if nargin<4 || isempty(quantity)
    quantity=abs(obj.CurrentStatus.GetPosition());
end

if isnan(price)
    error('Shit! The price is nan!')
end
quantity=abs(quantity);
if obj.GetPosition()>0
    realQuantity=0;
    if abs(obj.CurrentStatus.GetPosition())>=quantity
        realQuantity=quantity;
    elseif obj.CurrentStatus.GetPosition()<quantity&&obj.CurrentStatus.GetPosition()>=0
        realQuantity=obj.CurrentStatus.GetPosition();
    end
    transFee=realQuantity*price*obj.TradeCost*obj.CurrentStatus.Multiplier;
    %Keep Track of closed positions(apply when only 1 quantity is used)
    thisTransFee=realQuantity*obj.CurrentStatus.OpenPrice*obj.TradeCost*obj.CurrentStatus.Multiplier+transFee;
    thisGain=(price-obj.CurrentStatus.OpenPrice)*realQuantity*obj.CurrentStatus.Multiplier-thisTransFee;
    %           thisRet=log(price/obj.CurrentStatus.OpenPrice)-obj.TradeCost*2;
    %                 thisRet=log(1+thisGain / (obj.CurrentStatus.InitialFund+obj.CurrentStatus.ExtraFund));
    obj.CurrentStatus.RefreshUnrealized(price);
    thisRet = obj.CurrentStatus.UnrealizedPosRet;
    ThisCost = (obj.CurrentStatus.OpenPrice*obj.CurrentStatus.Multiplier*abs(obj.CurrentStatus.Position));
    obj.CBook.AddEntry(time,realQuantity,thisRet,thisGain,thisTransFee,ThisCost,i);
    %                 obj.CBook.AddEntry(time,realQuantity,thisRet,thisGain,thisTransFee,obj.CurrentStatus.Fund,i);
    if ~isreal(thisRet)
        error('There exist a complex!')
    end
    obj.TBook.AddEntry(time,price,-realQuantity,transFee,i);
    obj.CurrentStatus.RefreshRealized(thisRet,thisGain);
    %Refresh position
    obj.CurrentStatus.closelong(time,price,realQuantity);
end
if nargin==5 && ~isempty(i)
    obj.update(time,price,i);
else
    obj.update(time,price);
end
end