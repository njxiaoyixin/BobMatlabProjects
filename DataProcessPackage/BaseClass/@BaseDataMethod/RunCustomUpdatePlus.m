function FID=RunCustomUpdatePlus(obj,FID,FileName,SheetName,OutName,varargin)
if nargin<2
    FID=fopen([pwd,'\数据更新日志\',datestr(today,'yyyymmdd'),'.txt'],'at+');
end
CodeMap=obj.GetCodeMap(FileName,SheetName,OutName);
FID=RunBatchUpdatePlus(obj,CodeMap.Product,CodeMap.Exchange,CodeMap.ProductType,CodeMap.Country,obj.SDate,obj.EDate,FID,varargin{:});
end