function funOnMarketData(obj,varargin)

localSymbol=varargin{3};% 合约编号3
%遍历寻找contractId
currentLocalSymbol = arrayfun(@(x) obj.Contract(x).localSymbol,1:numel(obj.Contract),'UniformOutput',false);
idx = find(strcmpi(currentLocalSymbol,localSymbol),1);
if isempty(idx)
    disp([localSymbol,': ','No Corresponding Contract Found for Market Data!Adding New'])
    orderInfo.localSymbol = localSymbol;
     idx =  obj.AddContract(orderInfo);
     if isempty(idx)
         return
     end
end

obj.MarketData(idx,1).bidPrice           = varargin{4};% 买一价4
obj.MarketData(idx,1).bidSize            = varargin{5};%买一量5
obj.MarketData(idx,1).askPrice           = varargin{6};%卖一价6
obj.MarketData(idx,1).askSize            = varargin{7};% 卖一量7
obj.MarketData(idx,1).openPrice          = varargin{8};% 开盘价8
obj.MarketData(idx,1).highestPrice       = varargin{9};% 最高价9
obj.MarketData(idx,1).lowestPrice        = varargin{10};% 最低价10
obj.MarketData(idx,1).lastPrice          = varargin{11};% 最新价11
obj.MarketData(idx,1).openInterest       = varargin{12};% 持仓量12
obj.MarketData(idx,1).volume             = varargin{13};% 成交量13
obj.MarketData(idx,1).upperLimitPrice    = varargin{14};% 涨停价14
obj.MarketData(idx,1).lowerLimitPrice    = varargin{15};% 跌停价15
obj.MarketData(idx,1).preSettlementPrice = varargin{16};% 昨结算价16
obj.MarketData(idx,1).averagePrice       = varargin{17};% 今日平均价17
obj.MarketData(idx,1).updateTime         = varargin{18};%行情更新时间18
obj.MarketData(idx,1).updateMilliSecond  = varargin{19};%更新毫秒数为0或500 19

obj.MarketData(idx,1).pctChange          = obj.MarketData(idx,1).lastPrice/obj.MarketData(idx,1).preSettlementPrice-1;

% thisMarketData= struct('bidPrice',varargin{4},...
%     'bidSize',varargin{5},'askPrice',varargin{6},...
%     'askSize',varargin{7},'openPrice',varargin{8},...
%     'highestPrice',varargin{9},'lowestPrice',varargin{10},...
%     'lastPrice',varargin{11},'openInterest',varargin{12},...
%     'volume',varargin{13},'upperLimitPrice',varargin{14},...
%     'lowerLimitPrice',varargin{15},'preSettlementPrice',varargin{16},...
%     'averagePrice',varargin{17},'updateTime',varargin{18},...
%     'updateMilliSecond',varargin{19});
% if isempty(obj.MarketData)
%     obj.MarketData = thisMarketData;
% else
%     obj.MarketData(idx,1) = thisMarketData;
% end

% drawnow
end
