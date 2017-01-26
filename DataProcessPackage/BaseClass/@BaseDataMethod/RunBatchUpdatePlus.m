function FID=RunBatchUpdatePlus(obj,Product_List,Exchange_List,ProductType_List,Country_List,ThisSDate,ThisEDate,FID,varargin)
if nargin<8
    FID=fopen([pwd,'\数据更新日志\',datestr(today,'yyyymmdd'),'.txt'],'at+');
end
if nargin >= 6
    obj.SetProperties('SDate',ThisSDate);
end
if nargin >= 7
    obj.SetProperties('EDate',ThisEDate);
end
%输入Product List和Exchange List（二者数目必须相同），批量更新合约高频数据
tic
fprintf(FID,'%s\n','现在连接数据终端...');
APIConnect(obj);
fprintf(FID,'%s\n','数据终端已连接!');

for i=1:numel(Product_List)
    if ~any(isnan(Product_List{i}))
%         disp(Product_List{i});
        [ ThisTickerSet,~,ThisTickerSet_Backup ]=obj.F_GenerateTicker(Product_List{i},Exchange_List{i},ProductType_List{i},obj.SDate,obj.EDate,Country_List{i});
        obj.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TickerSet',ThisTickerSet,'TickerSet_Backup',ThisTickerSet_Backup);
        TitleStr = ['现在更新的品种：',obj.Product];
        fprintf(FID,'%s\n',TitleStr);
        FID=RunOneUpdatePlus(obj,obj.API,FID,varargin{:});
    end
end

APIDisconnect(obj);
toc
end