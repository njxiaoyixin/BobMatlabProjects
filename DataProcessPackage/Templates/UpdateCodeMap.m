function UpdateCodeMap(FileName,SheetName,OutName)
if nargin < 3
    FileName   = 'F:\工作文件\策略研究\BobQuantBox\DataProcess\Config/WindCodes.xlsx';
    SheetName  = '数据更新品种';
    OutName    = 'Config\WindCodeMap.xml';
end

[~,~,Raw]=xlsread(FileName,SheetName);
CodeMap.Product      = Raw(2:end,1);
CodeMap.ProductName  = Raw(2:end,2);
CodeMap.Exchange     = Raw(2:end,3);
CodeMap.ExchangeName = Raw(2:end,4);
CodeMap.ProductType  = Raw(2:end,5);
CodeMap.Country      = Raw(2:end,6);

currentCodeMap = struct;
CodemapFields = fieldnames(CodeMap);
for i=1:numel(CodeMap.Product)
    if ~isnan(CodeMap.Product{i})
        for k=1:numel(CodemapFields)
            if isnan(CodeMap.(CodemapFields{k}){i})
                currentCodeMap(i,1).(CodemapFields{k}) = [];
            else
                currentCodeMap(i,1).(CodemapFields{k}) = CodeMap.(CodemapFields{k}){i};
            end
        end
    end
end
xml_write(OutName,currentCodeMap);
% Pref.Str2Num = 'never';
% ss=xml_read('Config\Test.xml',Pref);
end