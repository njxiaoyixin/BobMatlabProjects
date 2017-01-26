function RunFullUpdate(obj)
CodeMap=obj.GetFullCodeMap;
RunBatchUpdate(obj,CodeMap.Product,CodeMap.Exchange,CodeMap.ProductType);
end