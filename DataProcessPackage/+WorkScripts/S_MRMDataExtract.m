%用来提取国内外铜的分钟及Tick数据
clear all
% addpath F:\工作文件\策略研究\高频数据处理\ReadTickData\国内外数据更新工具V20160111\国内商品高频数据读写工具包
s=WindPackage.ReadTick;
s.SetProperties('SDate',datenum('2010-1-1'),'EDate',datenum('2015-12-31'));
Product_List      = {'Y','P'};
Exchange_List     = {'DCE','DCE'};
ProductType_List  = {'FUT','FUT'};
%% 提取Tick（使用Wind数据源）
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[pwd,'/YP套利/',Product_List{i}]);
    %提取1分钟数据
    s.ReadProductTick_toCSV;
end
%% 提取分钟（使用Bloomberg数据源）
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[pwd,'/MRM套利/',Product_List{i}]);
    %提取1分钟数据
    s.ReadProductBar_toMAT(1);
end