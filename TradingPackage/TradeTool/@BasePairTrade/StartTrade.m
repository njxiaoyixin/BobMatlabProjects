function StartTrade(obj,side,ladderShift)
% side: 'BUY','SELL'
% ladderShift: -10 to 10, 0代表PriceLadder上的最新价，正数n代表价格增加n个minTick
%  负数-n代表减掉n个minTick
    if nargin<3
        ladderShift = 0;
    end
    % 以spread下单
    switch upper(side)
        case 'BUY'
            
        case 'SELL'
            
    end 
end