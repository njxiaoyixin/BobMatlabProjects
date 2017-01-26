function CancelId = CancelOrder(obj,orderId)%³·µ¥
obj.LoginId.Handle.cancelOrder(orderId);
CancelId = orderId;
end