function CodeMap=GetFullCodeMap(~)
FileName = 'EDBCodeMap.xml';
CodeMap=GetCodeMap(FileName);
end

function CodeMap=GetCodeMap(FileName)
[factorInfo,sFundaFactors,sTechFactors]=F_LoadFactorInfo(FileName);
tickers   = {sFundaFactors.BaseFactor.ticker};
funcNames = {sFundaFactors.BaseFactor.funcName};
tickers   = tickers(strcmpi(funcNames,'edb'));
names     = {sFundaFactors.BaseFactor.factorName};

Product     = tickers;
Exchange    = repmat({'EDB'},size(Product));
ProductType = repmat({'EDB'},size(Product));
Country     = repmat({'CN'},size(Product));

CodeMap = struct;
for i=1:numel(Product)
    CodeMap(i).Product      = Product{i};
    CodeMap(i).ProductName  = names{i};
    CodeMap(i).Exchange     = Exchange{i};
    CodeMap(i).ExchangeName = Exchange{i};
    CodeMap(i).ProductType  = ProductType{i};
    CodeMap(i).Country      = Country{i};
end
end