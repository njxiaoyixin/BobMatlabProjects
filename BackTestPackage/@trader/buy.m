function buy(obj,time,price,quantity,i)
if isnan(price)
    error('Shit! The price is nan!')
end
if obj.CurrentStatus.Fund < price
    error('The fund is inadaquate to open the position!')
end
quantity=abs(quantity);
if obj.CurrentStatus.GetPosition()<0
    error('Cannot buy without closing the short position!');
else
    transFee=price*abs(quantity)*obj.TradeCost;
    obj.TBook.AddEntry(time,price,quantity,transFee,i);
    obj.CurrentStatus.buy(time,price,quantity);
end
if nargin==5&& ~isempty(i)
    obj.update(time,price,i);
else
    obj.update(time,price);
end
end