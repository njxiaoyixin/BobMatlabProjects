function funOnTrade(obj,varargin)
tradeId = numel(obj.Trade)+1;
if numel(obj.Trade)>0
    currentOrderId = arrayfun(@(x) obj.Trade(x).orderId,1:numel(obj.Trade));
    thisIdx = find(currentOrderId==varargin{3},1,'last');
    if ~isempty(thisIdx)
        tradeId = thisIdx;
    end
end
obj.Trade(tradeId,1).orderId = varargin{3};
obj.Trade(tradeId,1).localSymbol = varargin{4};
obj.Trade(tradeId,1).isBuy = varargin{5};
obj.Trade(tradeId,1).isOpen =varargin{6};
obj.Trade(tradeId,1).thisTradeVolume = varargin{7};
obj.Trade(tradeId,1).thisTradePrice =varargin{8};
obj.Trade(tradeId,1).tradeTime = char(varargin{9});

% thisTrade = struct('orderId',varargin{3},'localSymbol',varargin{4},...
%     'isBuy',varargin{5},'isOpen',varargin{6},'thisTradeVolume',varargin{7},...
%     'thisTradePrice',varargin{8},'tradeTime',char(varargin{9}));
% if tradeId == 1
%     obj.Trade = thisTrade;
% else
%     obj.Trade(tradeId,1) = thisTrade;
% end
end