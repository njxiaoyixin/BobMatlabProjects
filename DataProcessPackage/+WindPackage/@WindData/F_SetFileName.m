function FileName      = F_SetFileName(~,Ticker,Date,Exchange,OutputFileType)
FileName=[upper(Exchange),lower(Ticker),'.',OutputFileType];
end