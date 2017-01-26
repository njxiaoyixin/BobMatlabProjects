function [UpperLine,MiddleLine, LowerLine]=AdjBOLL(Price,Length,Pct_Up,Pct_Down,Type)
% 计算利用分位点决定的布林带
% Pct_Up为上界分位点参数
% Pct_Down为下界分位点参数
if nargin==3
    Type=0;
end
UpperLine=nan(size(Price));
LowerLine=nan(size(Price));
UpperLine(Length:end)=arrayfun(@(x) prctile(Price((x-Length+1):x),Pct_Up),Length:numel(Price));
LowerLine(Length:end)=arrayfun(@(x) prctile(Price((x-Length+1):x),Pct_Down),Length:numel(Price));

%使用简单移动平均
switch Type
    case 0 %中线采用上下界的平均
        MiddleLine=(UpperLine+LowerLine)./2;
    case 1 %中线采用简单移动平均 SMA
        MiddleLine=tsmovavg(Price,'s',Length,1);
    case 2 %中线采用指数移动平均 EMA
        MiddleLine=tsmovavg(Price,'e',Length,2);
end