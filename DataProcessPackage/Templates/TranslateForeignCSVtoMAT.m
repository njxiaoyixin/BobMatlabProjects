%将已经有的csv文件全部转成.mat格式

ThisTargetFolder='F:\期货分笔数据mat';
sm         = WindPackage.ReadTick;
ThisSDate = today;
ThisEDate = today;
CodeMap=WindPackage.WindCtrInfo.GetFullCodeMap;
tic
for i = 1:numel(CodeMap.Product)
    if isnan(CodeMap.Product{i})
        continue
    end
    disp(CodeMap.Product{i})
    ThisProduct     = CodeMap.Product{i};
    ThisExchange    = CodeMap.Exchange{i};
    ThisProductType = CodeMap.ProductType{i};
    sm.SetProperties('Product',ThisProduct,'Exchange',ThisExchange,'ProductType',ThisProductType,'SDate',ThisSDate,'EDate',ThisEDate,'TargetFolder',ThisTargetFolder);
    sm.UpdateTickerSet;
    sm.ReadProductTick_CSVtoMAT_Divided();
    % s.ReadProductTick_CSVtoMAT_Concat
end
toc
