%用来提取国内外铜的分钟及Tick数据
clear all
% addpath F:\工作文件\策略研究\高频数据处理\ReadTickData\国内外数据更新工具V20160111\国内商品高频数据读写工具包
s=WindPackage.ReadTick;
s.SetProperties('SDate',datenum('2008-1-1'),'EDate',today-1);
Product_List      = {'Y','P','L','C','CS','M','RM','OI'};
Exchange_List     = {'DL','DL','DL','DL','DL','DL','ZZ','ZZ'};
ProductType_List  = {'FUT','FUT','FUT','FUT','FUT','FUT','FUT','FUT'};
TargetFolder      = 'F:\工作文件\策略研究\高频数据处理\ReadTickData\YH';
%% 提取Tick（使用Wind数据源）
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %提取1分钟数据
    s.ReadProductTick_toCSV;
end
%% 提取分钟（使用Wind数据源）
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %提取1分钟数据
%     s.ReadProductBar_MATtoMAT_Divided(1);
%     s.ReadProductBar_MATtoMAT_Concat;
    s.ReadProductBar_CSVtoCSV_Concat
end