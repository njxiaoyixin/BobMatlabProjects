function funOnPosition(obj,varargin)
localSymbol=varargin{3};% 合约编号3
%遍历寻找contractId
% if varargin{5} <= 0
%     return
% end

longPos=GetLongPos(obj.LoginId,lower(localSymbol));%返回某个合约的多头（买持）仓位。
shortPos=GetShortPos(obj.LoginId,lower(localSymbol));%返回某个合约的空头（卖持）仓位。
if (longPos >0 || shortPos >0) && varargin{5}<=0
    %已平仓位，不计入现有持仓
    return
end

if isempty(obj.Position)
    positionId = [];
else
    %     currentLocalSymbol = arrayfun(@(x) obj.Position(x).localSymbol,1:numel(obj.Position),'UniformOutput',false);
    currentLocalSymbol = {obj.Position.localSymbol};
    currentIsLong      = [obj.Position.isLong];
    contractId          = strcmpi(currentLocalSymbol,localSymbol);
    
    isLongId          = currentIsLong==varargin{4};
    positionId        = find(contractId & isLongId,1);
end
if isempty(positionId)
    positionId = numel(obj.Position)+1;
end
obj.Position(positionId,1).contractDetails.localSymbol = varargin{3};
obj.Position(positionId,1).localSymbol = varargin{3};
obj.Position(positionId,1).isLong = varargin{4};
obj.Position(positionId,1).volume = varargin{5};
obj.Position(positionId,1).realizedPNL =varargin{6};
obj.Position(positionId,1).positionPNL = varargin{7};
obj.Position(positionId,1).avgPositionPrice =varargin{8};
obj.Position(positionId,1).avgOpenPrice=varargin{9};
obj.Position(positionId,1).totalClosable=varargin{10};
obj.Position(positionId,1).todayClosable = varargin{11};

currentLocalSymbol  = [obj.Contract.localSymbol];
obj.Position(positionId,1).contractId = find(strcmpi(currentLocalSymbol,localSymbol),1);

% thisPosition = struct('localSymbol',varargin{3},'isLong',varargin{4},...
%     'volume',varargin{5},'closeProfit',varargin{6},'positionProfit',varargin{7},...
%     'avgPositionPrice',varargin{8},'avgOpenPrice',varargin{9},...
%     'totalClosable',varargin{10},'todayClosable',varargin{11});
% if isempty(obj.Position)
%     obj.Position = thisPosition;
% else
%     obj.Position(positionId,1) = thisPosition;
% end

end