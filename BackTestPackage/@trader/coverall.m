function coverall(obj,time,price,~,i)
quantity=obj.CurrentStatus.GetPosition();
if quantity > 0
    closelong(obj,time,price,[],i)
else
    closeshort(obj,time,price,[],i)
end
end