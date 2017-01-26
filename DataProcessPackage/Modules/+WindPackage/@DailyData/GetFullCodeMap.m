function CodeMap=GetFullCodeMap(~)
disp([datestr(now,31),'--Loading Local Data Update CodeMap from XML ...'])
Pref.Str2Num = 'never';
Pref.ReadSpec  = false;
Info=xml_read('Config\WindCodeMap.xml',Pref);
products={Info.ProductInfo.Product};
updateProducts = Info.Daily;
CodeMap = repmat(Info.ProductInfo(1),numel(updateProducts),1);
for iProduct = 1:numel(updateProducts)
    idx = strcmpi(updateProducts{iProduct},products);
    if any(idx)
            CodeMap(iProduct,1)= Info.ProductInfo(idx);
    else
        error('Updated Product not Found! Please update it in the xml!')
    end
end