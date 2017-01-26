classdef CSymbolData 
   % data class for handling
   properties
       symbol
       ask
       bid
       last
       high
       low
       close
       open
       lastUpdate
   end % properties
   
   methods
       function obj = CSymbolData(symbol)
           obj.symbol = symbol;
           obj.ask = nan;
           obj.bid = nan;
           obj.last = nan;
           obj.high = nan;
           obj.low = nan;
           obj.close = nan;
           obj.open =nan;
           obj.lastUpdate = nan;
       end
       
   end
end