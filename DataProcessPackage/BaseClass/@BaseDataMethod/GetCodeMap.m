function CodeMap=GetCodeMap(obj,FileName,SheetName,OutName)
if nargin<2
    SheetName = 1;
    OutName   =  'WindCodeMap.mat';
end
[~,~,Raw]=xlsread(FileName,SheetName);
CodeMap.Product      = Raw(2:end,1);
CodeMap.ProductName  = Raw(2:end,2);
CodeMap.Exchange     = Raw(2:end,3);
CodeMap.ExchangeName = Raw(2:end,4);
CodeMap.ProductType  = Raw(2:end,5);
CodeMap.Country      = Raw(2:end,6);
save(OutName,'CodeMap');
end