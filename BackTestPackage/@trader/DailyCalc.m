function DailyCalc(obj)
if isempty(obj.TimeVec)
    error('Trading has not Begun!');
end
AssetVec_lag1      = [obj.InitialFund;obj.AssetVec(1:end-1)];
UnitGainVec        = obj.AssetVec-AssetVec_lag1;
thisDayGain        = 0;
thisDayFundChange  = 0;
LastDayAsset       = obj.InitialFund;
if numel(obj.Fx)<2
    obj.Fx = ones(size(obj.TimeVec)).*obj.Fx;
end

for i=2:length(obj.TimeVec)
    thisDayFundChange      = thisDayFundChange+obj.FundChangeVec(i-1);
    thisDayGain            = thisDayGain+UnitGainVec(i-1);
    if obj.isAnotherDay(obj.TimeVec(i-1),obj.TimeVec(i))
        obj.DailyAssetVec      = [obj.DailyAssetVec;obj.AssetVec(i-1)];
        obj.DailyFundChangeVec = [obj.DailyFundChangeVec;thisDayFundChange];
        obj.DailyFx            = [obj.DailyFx;obj.Fx(i-1)];
        %                     if i==1980
        %                         obj.DailyAssetVec      = [obj.DailyAssetVec;obj.AssetVec(i-1)];
        %                         obj.DailyFundChangeVec = [obj.DailyFundChangeVec;thisDayFundChange];
        %                     end
        thisDayFundChange      = 0;
        %������������ֵ - ���ʽ���� - ����������ֵ��/����������ֵ
        % ����һ���� ln(1+R) �ɶ���������
        if ~isnan(LastDayAsset) && LastDayAsset~=0
            obj.DailyRetVec        = [obj.DailyRetVec;log((obj.AssetVec(i-1)-LastDayAsset-thisDayFundChange)/LastDayAsset+1)];
        else
            obj.DailyRetVec    = [obj.DailyRetVec;0];%����ƽ������ô�㣿
        end
        obj.DailyGainVec       = [obj.DailyGainVec;thisDayGain];
        obj.DateVec            = [obj.DateVec;floor(obj.TimeVec(i-1))];
        %�µ�һ�쿪ʼ���³�ʼ��
        thisDayGain            = UnitGainVec(i);
        thisDayFundChange      = 0;
        LastDayAsset           = obj.AssetVec(i-1);
    end
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
        obj.DailyAssetVec         = [obj.DailyAssetVec;obj.AssetVec(end)];
        obj.DailyRetVec       = [obj.DailyRetVec;thisDayRet];
        obj.DailyGainVec      = [obj.DailyGainVec;thisDayGain];
        obj.DateVec           = [obj.DateVec;floor(obj.TimeVec(end))];
        obj.DailyFundChangeVec= [obj.DailyFundChangeVec;thisDayFundChange];
    end
end
end