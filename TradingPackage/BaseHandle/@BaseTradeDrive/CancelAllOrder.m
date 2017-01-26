function CancelAllOrder(obj)
if numel(obj.Order) <= 0
    return
end
for idx=1:numel(obj.Order)
    %                 if ~isempty(regexp(obj.Order(idx).StatusMsg,'未成交','once')) || ~isempty(regexp(obj.Order(idx).StatusMsg,'部分成交','once'))
    obj.CancelOrder(obj.Order(idx).orderId)
    %                 end
end
end