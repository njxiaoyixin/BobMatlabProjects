function [cancelId,remark] = CancelDraftOrder(obj,draftId)
%撤掉DraftOrder里面的订单，并停止所有的轮询
StopMsg = {'Finished','Error_Finished'};
if ~any(strcmpi(obj.OrderDraft(draftId).status,StopMsg)) || regexp(obj.OrderDraft(draftId).remark,'轮询次数到达','Once')
    cancelId = -1;
    remark   = obj.OrderDraft(draftId).remark;
else
    cancelId = obj.CancelOrder(obj.OrderDraft(draftId).orderId);
    obj.OrderDraft(draftId).status = 'Finished';
    obj.OrderDraft(draftId).remark = '已停止';
    remark   = ['OrderDraft ',num2str(draftId),' 撤单成功！'];
end
end