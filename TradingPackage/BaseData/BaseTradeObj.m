classdef BaseTradeObj < handle
    properties(SetObservable,AbortSet)
        name
        type
        obj
    end
end