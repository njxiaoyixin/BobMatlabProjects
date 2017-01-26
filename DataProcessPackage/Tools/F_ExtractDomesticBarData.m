function F_ExtractDomesticBarData(Product_List,Exchange_List,ProductType_List,SDate,EDate,TargetFolder,Interval)
%提取指定期货产品的分钟数据
if nargin < 7
    Interval = 1;
end

if nargin < 6
    TargetFolder      = [pwd,'/','Data'];
end
if ~exist(TargetFolder,'dir')
    mkdir(TargetFolder)
end
    
if nargin < 5
    EDate = today;
end
if nargin < 4
    SDate = datenum('2010-1-1');
end

addpath F:\工作文件\策略研究\高频数据处理\ReadTickData\国内外数据更新工具V20160114\
s=WindPackage.ReadTick;
s.SetProperties('SDate',SDate,'EDate',EDate);

%% 提取分钟（使用Wind数据源）
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}],'ProductType',ProductType_List{i});
    %提取1分钟数据
%     s.ReadProductBar_MATtoMAT_Divided(Interval);
    s.ReadProductBar_MATtoMAT_Concat(Interval);
end

end