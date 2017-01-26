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
        %（当天收盘市值 - 净资金出入 - 昨天收盘市值）/昨天收盘市值
        % 另起一列求 ln(1+R) 成对数收益率
        if ~isnan(LastDayAsset) && LastDayAsset~=0
            obj.DailyRetVec        = [obj.DailyRetVec;log((obj.AssetVec(i-1)-LastDayAsset-thisDayFundChange)/LastDayAsset+1)];
        else
            obj.DailyRetVec    = [obj.DailyRetVec;0];%日内平仓了怎么算？
        end
        obj.DailyGainVec       = [obj.DailyGainVec;thisDayGain];
        obj.DateVec            = [obj.DateVec;floor(obj.TimeVec(i-1))];
        %新的一天开始重新初始化
        thisDayGain            = UnitGainVec(i);
        thisDayFundChange      = 0;
        LastDayAsset           = obj.AssetVec(i-1);
    end
end

%Push back the last day
thisDayRet=log((obj.AssetVec(end)-LastDayAsset-thisDayFundChange)/LastDayAsset+1);
if isempty(obj.DateVec)%当一天都没有
    obj.DailyAssetVec         = [obj.DailyAssetVec;obj.AssetVec(end)];
    obj.DailyRetVec           = [obj.DailyRetVec;thisDayRet];
    obj.DailyGainVec          = [obj.DailyGainVec;thisDayGain];
    obj.DateVec               = [obj.DateVec;floor(obj.TimeVec(end))];
    obj.DailyFundChangeVec    = [obj.DailyFundChangeVec;thisDayFundChange];
else
    if obj.DateVec(end)~=floor(obj.TimeVec(end))%当数据不满一整天（主要是为了防止end报错）
        obj.DailyAssetVec         = [obj.DailyAssetVec;obj.AssetVec(end)];
        obj.DailyRetVec       = [obj.DailyRetVec;thisDayRet];
        obj.DailyGainVec      = [obj.DailyGainVec;thisDayGain];
        obj.DateVec           = [obj.DateVec;floor(obj.TimeVec(end))];
        obj.DailyFundChangeVec= [obj.DailyFundChangeVec;thisDayFundChange];
    end
end
end