% run UpdateBaseFactors
% run ConcatFactors
%%
alpha = 0.1;
%%
ConcatFactors;
Config = xml_read('Config.xml');
DataDir      = Config.DataDir;
load(fullfile(DataDir,'Data','CodeMap'));
load(fullfile(DataDir,'Data','PxActive'));
load(fullfile(DataDir,'Data','Factors'));

StrategyReturn = nan(numel(TradeDay.Daily),numel(CodeMap));
Position = zeros(numel(TradeDay.Daily),numel(CodeMap));
N_Sample = 50;
for iProduct = 1:numel(CodeMap)    
    product = CodeMap(iProduct).product;
    disp([datestr(now,31),': Now Fitting Model for Product - ',product])
    n =0;
    for iTradeDay = 1:numel(TradeDay.LF)
        if ~isnan(FactorReturn(iTradeDay,iProduct))   
            n=n+1;
        end
        if n<=N_Sample  
            continue
        end
        inSampleIdx = iTradeDay-N_Sample:iTradeDay-1;
        inSampleData   = FactorData.(product)(inSampleIdx,:);
        inSampleReturn = double(FactorReturn(inSampleIdx,iProduct)>0);
        outSampleData  = FactorData.(product)(iTradeDay,:);
        % Zscore Transform
        [N_inSampleData,nm,ns]= nanzscore(inSampleData);
        N_outSampleData = (outSampleData-nm)./ns;
        % Construct PCA
        [coeff,score] = F_ReduceDim(N_inSampleData);
        % Execute Forecast
        [outSampleReturn_forecast,accuracy_insample]=F_ExecForcast(score,inSampleReturn,N_outSampleData*coeff);
        % Process Results
        PositionIdx = find(TradeDay.Daily>=TradeDay.LF(iTradeDay),1,'first');
        if outSampleReturn_forecast >0.5+alpha
            Position(PositionIdx:end,iProduct) = 1;
        elseif outSampleReturn_forecast <0.5-alpha
            Position(PositionIdx:end,iProduct) = -1;
        else
            Position(PositionIdx:end,iProduct) = 0;
        end
    end
    thisStrategyReturn = Position(:,iProduct).*FactorReturn_Daily(:,iProduct);
    thisStrategyReturn(isnan(thisStrategyReturn))=0;
    StrategyReturn(:,iProduct) = thisStrategyReturn;
end
%% Graph
DailyRetVec = nansum(StrategyReturn,2)/numel(CodeMap);
subplot(2,2,1)
FactorReturn_Daily(isnan(FactorReturn_Daily)) = 0;
plot(TradeDay.Daily,[cumsum(nanmean(FactorReturn_Daily,2)),cumsum(FactorReturn_Daily)]);datetick('x','yyyy-mm-dd');legend(['Total',{CodeMap.product}])
title('Price')
subplot(2,2,2)
plot(TradeDay.Daily,cumsum(DailyRetVec));datetick('x','yyyy-mm-dd');
title('Strategy Return')
subplot(2,2,3)
plot(TradeDay.Daily,[cumsum(DailyRetVec),cumsum(StrategyReturn)]);datetick('x','yyyy-mm-dd');legend(['Total',{CodeMap.product}])
title('Strategy Return')
subplot(2,2,4)
hist(DailyRetVec,50);
title('DailyReturnDist')
