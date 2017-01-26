classdef BasePairStrategy < BaseStrategy
     properties
        Signal
        Parity
        StrategyPosition
        Position@BasePosition
        UserData% copper,gold,goldfx,goldparity
     end
    
     methods
         UpdateParity(obj,varargin)
         UpdatePosition(obj)
         UpdateSignal(obj)
     end
end