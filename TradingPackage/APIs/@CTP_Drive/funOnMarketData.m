function funOnMarketData(obj,varargin)

localSymbol=varargin{3};% ��Լ���3
%����Ѱ��contractId
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

obj.MarketData(idx,1).bidPrice           = varargin{4};% ��һ��4
obj.MarketData(idx,1).bidSize            = varargin{5};%��һ��5
obj.MarketData(idx,1).askPrice           = varargin{6};%��һ��6
obj.MarketData(idx,1).askSize            = varargin{7};% ��һ��7
obj.MarketData(idx,1).openPrice          = varargin{8};% ���̼�8
obj.MarketData(idx,1).highestPrice       = varargin{9};% ��߼�9
obj.MarketData(idx,1).lowestPrice        = varargin{10};% ��ͼ�10
obj.MarketData(idx,1).lastPrice          = varargin{11};% ���¼�11
obj.MarketData(idx,1).openInterest       = varargin{12};% �ֲ���12
obj.MarketData(idx,1).volume             = varargin{13};% �ɽ���13
obj.MarketData(idx,1).upperLimitPrice    = varargin{14};% ��ͣ��14
obj.MarketData(idx,1).lowerLimitPrice    = varargin{15};% ��ͣ��15
obj.MarketData(idx,1).preSettlementPrice = varargin{16};% ������16
obj.MarketData(idx,1).averagePrice       = varargin{17};% ����ƽ����17
obj.MarketData(idx,1).updateTime         = varargin{18};%�������ʱ��18
obj.MarketData(idx,1).updateMilliSecond  = varargin{19};%���º�����Ϊ0��500 19

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
