%用来提取国内外铜的分钟及Tick数据
clear all
dbstop if error
% addpath F:\工作文件\策略研究\高频数据处理\ReadTickData\国内外数据更新工具V20160111\国内商品高频数据读写工具包
Product_List      = {'SI','AG'};
Exchange_List     = {'CM','SQ'};
ProductType_List  = {'FUT','FUT','FUT'};
% TargetFolder      = 'F:\Wind分钟数据';
TargetFolder      = 'F:\Test';
%% 提取Tick（使用Wind数据源）
s=WindPackage.TickData;
s.SetProperties('SDate',datenum('2015-1-1'),'EDate',datenum('2015-12-31'),'DataSource','F:\期货分笔数据mat');
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',TargetFolder);
    %提取1分钟数据
%     s.ReadProduct_Tick2Tick_CSV2CSV_Divided;
    s.ReadProduct_Divided('Tick','Tick','mat','mat',1)
%     s.ReadProduct_Concat('Tick','Bar','mat','mat')
end
%% 提取分钟（使用Wind数据源）
s=WindPackage.TickData;
s.SetProperties('SDate',datenum('2016-1-1'),'EDate',today-1,'DataSource','F:\期货分笔数据mat');
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %提取1分钟数据
    s.ReadProduct_Divided('Tick','Bar','mat','mat',1);
    s.ReadProduct_Concat('Tick','Bar','mat','mat');
end

%% 提取分钟（使用Bloomberg分钟数据源）
s=BloombergPackage.BarData;
s.SetProperties('SDate',datenum('2016-7-1'),'EDate',today-1,'DataSource','F:/Bloomberg分钟数据');
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %提取1分钟数据
    s.ReadProduct_Tick2Bar_CSV2MAT_Divided(1);
    s.ReadProduct_Tick2Bar_CSV2MAT_Concat
%     s.ReadProduct_Tick2Bar_MAT2MAT_Concat;
end

%% 提取日数据（使用Bloomberg分钟数据源）
s=BloombergPackage.ReadDaily;
s.SetProperties('SDate',datenum('2016-7-1'),'EDate',today-1,'DataSource','F:\Bloomberg分钟数据');
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %提取1分钟数据
    s.ReadProduct_Divided('Bar','Day','csv','mat',1);
    s.ReadProduct_Concat('Day','Day','mat','mat');
%     s.ReadProduct_Tick2Bar_MAT2MAT_Concat;
end
%% 提取日数据，并设置指定的时间区间（使用Bloomberg分钟数据源）
s=BloombergPackage.ReadDaily;
s.SetProperties('SDate',datenum('2015-7-1'),'EDate',today-1);
s.SetProperties('OpenTime',mod(datenum('16:00:01'),1),'SettleTime',mod(datenum('9:29:55'),1),'TimeZone','EST')
% s.SetProperties('OpenTime',mod(datenum('15:00:01'),1),'SettleTime',mod(datenum('15:00:00'),1)) %默认大陆时间
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %提取1分钟数据
    s.ReadProduct_Tick2Bar_CSV2MAT_Divided(1);
    s.ReadProduct_Tick2Bar_CSV2MAT_Concat
%     s.ReadProduct_Tick2Bar_MAT2MAT_Concat;
end


%% 提取日数据（使用Wind数据源）
s=WindPackage.ReadDaily;
s.SetProperties('SDate',datenum('2015-7-1'),'EDate',today-1);
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i},'Daily']);
    %提取1分钟数据
    s.ReadProduct_Tick2Bar_MAT2MAT_Divided(1);
    s.ReadProduct_Tick2Bar_MAT2MAT_Concat
%     s.ReadProduct_Tick2Bar_MAT2MAT_Concat;
end
%% 提取日数据，并设置指定的时间区间（使用Wind数据源）
s=WindPackage.ReadDaily;
s.SetProperties('SDate',datenum('2015-1-1'),'EDate',today-1,'DataSource','F:\期货分笔数据mat');
s.SetProperties('OpenTime',mod(datenum('16:00:01'),1),'SettleTime',mod(datenum('9:29:55'),1),'TimeZone','CN')
% s.SetProperties('OpenTime',mod(datenum('15:00:01'),1),'SettleTime',mod(datenum('15:00:00'),1)) %默认大陆时间
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder','F:\Wind日数据');
    %提取日数据
    s.ReadProduct_Divided('Tick','Bar','mat','mat',1)
    s.ReadProduct_Concat('Tick','Bar','mat','mat')
end

%% 提取分钟（使用CQG数据源）
Product_List      = {'ZSE','ZLE','ZME'};
Exchange_List     = {'CB','CB','CB'};
ProductType_List  = {'FUT','FUT','FUT'};
TargetFolder      = 'F:\CQG分钟数据';

s=CQGPackage.ReadTick;
s.SetProperties('SDate',datenum('2011-4-1'),'EDate',datenum('2015-12-31'));
for i=3%:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',TargetFolder);
    %提取1分钟数据
    s.ReadProduct_Divided('TICK','Bar','TS','mat',1)
end

