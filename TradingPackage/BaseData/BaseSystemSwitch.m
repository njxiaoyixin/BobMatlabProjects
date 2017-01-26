classdef BaseSystemSwitch < handle
    properties(SetObservable,AbortSet)
        isTrade      = 0
        InitFinished = 0
        MDDConn      = 0
    end
end