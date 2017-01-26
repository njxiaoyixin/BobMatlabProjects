function [UpperLine,MiddleLine, LowerLine]=BOLL(Price,Length,Width,Type)
% ���㲼�ִ�����ز���
if nargin==3
    Type=0;
end

if Length > numel(Price)
    error('The number of data is less than the window! Exit.')
end

MovStd=nan(size(Price));
MovStd(Length:end)=arrayfun(@(x) std(Price((x-Length+1):x)),Length:numel(Price));

%ʹ�ü��ƶ�ƽ��
switch Type
    case 0 
        MiddleLine=tsmovavg(Price,'s',Length,1);
        UpperLine=MiddleLine+Width*MovStd;
        LowerLine=MiddleLine-Width*MovStd;
    case 1 
        MiddleLine=tsmovavg(Price,'e',Length,2);
        UpperLine=MiddleLine+Width*MovStd;
        LowerLine=MiddleLine-Width*MovStd;
end