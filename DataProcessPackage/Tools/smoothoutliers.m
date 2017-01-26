function [B,idx,Outliers] = smoothoutliers(Data,Window,Trigger)
% ����ȥ��Data�е��쳣ֵ
% �㷨�� ����Data����Windowȡ�ƶ�ƽ�����ƶ���׼�
%        ��ĳһ�����ݵ��ֵ(x-mean)/std�ľ���ֵ����Triggerʱ����ȥ���õ�
if nargin <3
    Trigger  = 10;
end
if nargin <2
    Window   = 1000;
end
Data2 = Data;
%�����ƶ�ƽ���ķ�ʽ��ȥ��
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