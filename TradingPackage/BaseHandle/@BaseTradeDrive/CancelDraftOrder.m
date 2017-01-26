function [cancelId,remark] = CancelDraftOrder(obj,draftId)
%����DraftOrder����Ķ�������ֹͣ���е���ѯ
StopMsg = {'Finished','Error_Finished'};
if ~any(strcmpi(obj.OrderDraft(draftId).status,StopMsg)) || regexp(obj.OrderDraft(draftId).remark,'��ѯ��������','Once')
    cancelId = -1;
    remark   = obj.OrderDraft(draftId).remark;
else
    cancelId = obj.CancelOrder(obj.OrderDraft(draftId).orderId);
    obj.OrderDraft(draftId).status = 'Finished';
    obj.OrderDraft(draftId).remark = '��ֹͣ';
    remark   = ['OrderDraft ',num2str(draftId),' �����ɹ���'];
end
end