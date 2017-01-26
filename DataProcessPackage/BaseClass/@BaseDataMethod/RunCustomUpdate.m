function RunCustomUpdate(obj,FileName,SheetName,OutName)
CodeMap=obj.GetCodeMap(FileName,SheetName,OutName);
RunBatchUpdate(obj,CodeMap.Product,CodeMap.Exchange,CodeMap.ProductType,CodeMap.Country,obj.SDate,obj.EDate);
end