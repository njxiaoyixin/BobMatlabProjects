function RunBatchUpdate(obj,Product_List,Exchange_List,ProductType_List,ThisSDate,ThisEDate)
if nargin >= 5
    obj.SetProperties('SDate',ThisSDate);
end
if nargin >= 6
    obj.SetProperties('EDate',ThisEDate);
end
%输入Product List和Exchange List（二者数目必须相同），批量更新合约高频数据
tic
APIConnect(obj);
for i=1:numel(Product_List)
    disp(Product_List{i});
    %注意：郑州的Ticker不一样
    [ ThisTickerSet ]=obj.F_GenerateTicker(Product_List{i},Exchange_List{i},ProductType_List{i},obj.SDate,obj.EDate);
    obj.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TickerSet',ThisTickerSet);
    RunOneUpdate(obj,obj.API);
end
APIDisconnect(obj);
toc
end