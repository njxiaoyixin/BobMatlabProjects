classdef BaseAccount
    properties
        updateTime%
        preBalance
        balance%
        available%
        commission
        frozenCommission
        margin%
        frozenMargin
        realizedPNL%
        unrealizedPNL%
        positionPNL
        other
    end
end