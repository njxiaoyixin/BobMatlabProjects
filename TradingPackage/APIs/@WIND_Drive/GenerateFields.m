function [InternalFields,WindFields] = GenerateFields(obj)
InternalFields     = 'bidPrice,bidSize,askPrice,askSize,openPrice,highestPrice,lowestPrice,lastPrice,lastSize,openInterest,volume,amount,upperLimitPrice,lowerLimitPrice,preClose,averagePrice,preSettlementPrice,pctChange';
WindFields         = 'rt_bid1,rt_bsize1,rt_ask1,rt_asize1,rt_open,rt_high,rt_low,rt_latest,rt_last_vol,rt_oi,rt_vol,rt_amt,rt_high_limit,rt_low_limit,rt_pre_close,rt_vwap,rt_pre_settle,rt_pct_chg';
%             InternalFields     = 'bidPrice,bidSize,askPrice,askSize,openPrice,highestPrice,lowestPrice,lastPrice,volume,upperLimitPrice,lowerLimitPrice,preSettlementPrice,averagePrice';
%             WindFields         = 'rt_bid1,rt_bsize1,rt_ask1,rt_asize1,rt_open,rt_high,rt_low,rt_latest,rt_vol,rt_high_limit,rt_low_limit,rt_preclose,rt_vwap';
InternalFields     = regexp(InternalFields,',','split');
WindFields         = regexp(WindFields,',','split');
end