function [InternalFields,WindFields] = GenerateFields(~)
InternalFields     = {'Open','High','Low','Close','Volume','Amount','PreClose','OpenInt','OIChg','VWAP','PctChgSettlement','Chg'};
WindFields         = {'open','high','low','close','volume','amt','pre_close','oi','oi_chg','vwap','pct_chg_settlement','chg'};
%             InternalFields     = 'bidPrice,bidSize,askPrice,askSize,openPrice,highestPrice,lowestPrice,lastPrice,volume,upperLimitPrice,lowerLimitPrice,preSettlementPrice,averagePrice';
%             WindFields         = 'rt_bid1,rt_bsize1,rt_ask1,rt_asize1,rt_open,rt_high,rt_low,rt_latest,rt_vol,rt_high_limit,rt_low_limit,rt_preclose,rt_vwap';
% InternalFields     = regexp(InternalFields,',','split');
% WindFields         = regexp(WindFields,',','split');
end