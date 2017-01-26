classdef BaseQuoteDrive <  BaseDriveMethod & BaseDriveData
    properties(SetObservable)
        MarketData@BaseMarketData       % 每个合约的行情数据
    end
    methods %行情模块
        GetMarketData(obj,ContractId)%获取市场行情
    end
    methods(Access = protected)
        funOnMarketData(obj,varargin)  % 当行情发生变化时的操作
    end
end