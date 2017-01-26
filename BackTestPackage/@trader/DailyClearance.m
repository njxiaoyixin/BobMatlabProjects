function DailyClearance(obj,Date,Settle)
% ���������
% Date:�� ��������
% Settle: �����
% ʹ�øú���ʱ��obj.AssetVec,obj.TimeVec,obj.
if isempty(obj.TimeVec)
    error('Trading has not Begun!');
end
if nargin < 2
    Date = obj.TimeVec(end);
end
if isempty(obj.DateVec)
    LastDayAsset  = obj.InitialFund;
else
    LastDayAsset  = obj.DailyAssetVec(find(obj.DateVec<=Date,1,'last'));
end
AssetVec_Lag1     = [LastDayAsset;obj.AssetVec(1:end-1)];
UnitGainVec        = obj.AssetVec-AssetVec_Lag1;
thisDayGain        = 0;
thisDayFundChange  = 0;
for i=1:length(obj.TimeVec)
    thisDayFundChange      = thisDayFundChange+obj.FundChangeVec(i);
    thisDayGain            = thisDayGain+UnitGainVec(i);
    %                 if obj.isAnotherDay(obj.TimeVec(i-1),obj.TimeVec(i))
    %                     obj.DailyAssetVec      = [obj.DailyAssetVec;obj.AssetVec(i-1)];
    %                     obj.DailyFundChangeVec = [obj.DailyFundChangeVec;thisDayFundChange];
    %                     if i==1980
    %                         obj.DailyAssetVec      = [obj.DailyAssetVec;obj.AssetVec(i-1)];
    %                         obj.DailyFundChangeVec = [obj.DailyFundChangeVec;thisDayFundChange];
    %                     end
    %                     thisDayFundChange      = 0;
    %������������ֵ - ���ʽ���� - ����������ֵ��/����������ֵ
    % ����һ���� ln(1+R) �ɶ���������
    %                     if ~isnan(LastDayAsset) && LastDayAsset~=0
    %                         obj.DailyRetVec        = [obj.DailyRetVec;log((obj.AssetVec(i-1)-LastDayAsset-thisDayFundChange)/LastDayAsset+1)];
    %                     else
    %                         obj.DailyRetVec    = [obj.DailyRetVec;0];%����ƽ������ô�㣿
    %                     end
    %                     obj.DailyGainVec       = [obj.DailyGainVec;thisDayGain];
    %                     obj.DateVec            = [obj.DateVec;floor(obj.TimeVec(i-1))];
    %                     %�µ�һ�쿪ʼ���³�ʼ��
    %                     thisDayGain            = UnitGainVec(i);
    %                     thisDayFundChange      = 0;
    %                     LastDayAsset           = obj.AssetVec(i-1);
    %                 end
end

%Push back the last day
thisDayRet=log((obj.AssetVec(end)-LastDayAsset-thisDayFundChange)/LastDayAsset+1);
if isempty(obj.DateVec)%��һ�춼û��
    obj.DailyAssetVec         = [obj.DailyAssetVec;obj.AssetVec(end)];
    obj.DailyRetVec           = [obj.DailyRetVec;thisDayRet];
    obj.DailyGainVec          = [obj.DailyGainVec;thisDayGain];
    obj.DateVec               = [obj.DateVec;floor(obj.TimeVec(end))];
    obj.DailyFundChangeVec    = [obj.DailyFundChangeVec;thisDayFundChange];
else
    if obj.DateVec(end)~=floor(obj.TimeVec(end))%�����ݲ���һ���죨��Ҫ��Ϊ�˷�ֹend����
        obj.DailyAssetVec     = [obj.DailyAssetVec;obj.AssetVec(end)];
        obj.DailyRetVec       = [obj.DailyRetVec;thisDayRet];
        obj.DailyGainVec      = [obj.DailyGainVec;thisDayGain];
        obj.DateVec           = [obj.DateVec;floor(obj.TimeVec(end))];
        obj.DailyFundChangeVec= [obj.DailyFundChangeVec;thisDayFundChange];
    end
end
end