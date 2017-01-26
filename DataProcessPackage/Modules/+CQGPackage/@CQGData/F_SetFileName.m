function FileName = F_SetFileName(obj,Ticker,Date,Exchange,OutputFileType)
if ~isempty(Date)
    FileName=[upper(Ticker),'_',datestr(Date,'yyyymm'),'.',OutputFileType];
else
    FileName=[upper(Ticker),'.',OutputFileType];
end
end