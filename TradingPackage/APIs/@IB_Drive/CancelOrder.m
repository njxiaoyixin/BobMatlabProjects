function CancelId = CancelOrder(obj,orderId)%����
obj.LoginId.Handle.cancelOrder(orderId);
CancelId = orderId;
end