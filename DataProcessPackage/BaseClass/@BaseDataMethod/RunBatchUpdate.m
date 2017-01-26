function RunBatchUpdate(obj,Product_List,Exchange_List,ProductType_List,ThisSDate,ThisEDate)
if nargin >= 5
    obj.SetProperties('SDate',ThisSDate);
end
if nargin >= 6
    obj.SetProperties('EDate',ThisEDate);
end
%����Product List��Exchange List��������Ŀ������ͬ�����������º�Լ��Ƶ����
tic
APIConnect(obj);
for i=1:numel(Product_List)
    disp(Product_List{i});
    %ע�⣺֣�ݵ�Ticker��һ��
    [ ThisTickerSet ]=obj.F_GenerateTicker(Product_List{i},Exchange_List{i},ProductType_List{i},obj.SDate,obj.EDate);
    obj.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TickerSet',ThisTickerSet);
    RunOneUpdate(obj,obj.API);
end
APIDisconnect(obj);
toc
end