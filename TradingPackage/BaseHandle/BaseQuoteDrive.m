classdef BaseQuoteDrive <  BaseDriveMethod & BaseDriveData
    properties(SetObservable)
        MarketData@BaseMarketData       % ÿ����Լ����������
    end
    methods %����ģ��
        GetMarketData(obj,ContractId)%��ȡ�г�����
    end
    methods(Access = protected)
        funOnMarketData(obj,varargin)  % �����鷢���仯ʱ�Ĳ���
    end
end