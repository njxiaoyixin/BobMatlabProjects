function [B,idx,Outliers] = smoothoutliers(Data,Window,Trigger)
% 用于去除Data中的异常值
% 算法： 遍历Data，以Window取移动平均及移动标准差，
%        当某一个数据点的值(x-mean)/std的绝对值大于Trigger时，则去除该点
if nargin <3
    Trigger  = 10;
end
if nargin <2
    Window   = 1000;
end
Data2 = Data;
%采用移动平均的方式来去除
idx     = zeros(size(Data));
for i=1:(numel(Data)-1)
%     if Data(i)>16000
%         disp('shit!')
%     end
    if i<=Window
        Mean = nanmean(Data2(1:Window));
        Std  = nanstd(Data2(1:Window));
    else
        Mean = nanmean(Data2((i-Window):i));
        Std  = nanstd(Data2((i-Window):i));
    end
    if (Data2(i+1)-Mean)/Std > Trigger || (Data2(i+1)-Mean)/Std < -Trigger
        idx(i+1)   = 1;
        Data2(i+1) = nan;
    end
end
idx         = find(idx>0);
BIdx        = setdiff(1:numel(Data),idx);
B           = Data(BIdx);
Outliers    = Data(idx);