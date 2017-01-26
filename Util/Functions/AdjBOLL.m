function [UpperLine,MiddleLine, LowerLine]=AdjBOLL(Price,Length,Pct_Up,Pct_Down,Type)
% �������÷�λ������Ĳ��ִ�
% Pct_UpΪ�Ͻ��λ�����
% Pct_DownΪ�½��λ�����
if nargin==3
    Type=0;
end
UpperLine=nan(size(Price));
LowerLine=nan(size(Price));
UpperLine(Length:end)=arrayfun(@(x) prctile(Price((x-Length+1):x),Pct_Up),Length:numel(Price));
LowerLine(Length:end)=arrayfun(@(x) prctile(Price((x-Length+1):x),Pct_Down),Length:numel(Price));

%ʹ�ü��ƶ�ƽ��
switch Type
    case 0 %���߲������½��ƽ��
        MiddleLine=(UpperLine+LowerLine)./2;
    case 1 %���߲��ü��ƶ�ƽ�� SMA
        MiddleLine=tsmovavg(Price,'s',Length,1);
    case 2 %���߲���ָ���ƶ�ƽ�� EMA
        MiddleLine=tsmovavg(Price,'e',Length,2);
end