function FID=RunBatchUpdatePlus(obj,Product_List,Exchange_List,ProductType_List,Country_List,ThisSDate,ThisEDate,FID,varargin)
if nargin<8
    FID=fopen([pwd,'\���ݸ�����־\',datestr(today,'yyyymmdd'),'.txt'],'at+');
end
if nargin >= 6
    obj.SetProperties('SDate',ThisSDate);
end
if nargin >= 7
    obj.SetProperties('EDate',ThisEDate);
end
%����Product List��Exchange List��������Ŀ������ͬ�����������º�Լ��Ƶ����
tic
fprintf(FID,'%s\n','�������������ն�...');
APIConnect(obj);
fprintf(FID,'%s\n','�����ն�������!');

for i=1:numel(Product_List)
    if ~any(isnan(Product_List{i}))
%         disp(Product_List{i});
        [ ThisTickerSet,~,ThisTickerSet_Backup ]=obj.F_GenerateTicker(Product_List{i},Exchange_List{i},ProductType_List{i},obj.SDate,obj.EDate,Country_List{i});
        obj.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TickerSet',ThisTickerSet,'TickerSet_Backup',ThisTickerSet_Backup);
        TitleStr = ['���ڸ��µ�Ʒ�֣�',obj.Product];
        fprintf(FID,'%s\n',TitleStr);
        FID=RunOneUpdatePlus(obj,obj.API,FID,varargin{:});
    end
end

APIDisconnect(obj);
toc
end