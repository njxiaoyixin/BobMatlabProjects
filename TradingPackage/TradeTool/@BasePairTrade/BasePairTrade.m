classdef BasePairTrade < BaseStrategy
    properties(SetObservable,AbortSet)
        PairContract@BasePairContract
        % ��������Խ�����ز���
        PriceLadder @BasePriceLadder
    end
    
    events
        RelExecuted%�����ȳɽ��������µ�������
    end
    
    methods
        function obj=BasePairTrade
            
        end
        pairContractId = AddPairContract(obj,pairContractInfo)
        ClearPairInfo(obj,pairContractId)  %���PairContract����Ϣ
        newPairContractId=CopyPairInfo(obj,pairContractId)  % ����ĳ��PairContract����Ϣ
        ReqMktData(obj)
        
        StartTrade(obj,spread)  %��ָ����Spread���µ�pair���ף�spreadʡ��ʱĬ�����̿��µ�
        StopTrade(obj)
        CancelOrder(obj)
        CoverDeficit(obj) %��ƽ����ͷ��
        % �������������ϲ�ϵͳ�����ѻ�������Խ��׹���ʵ�ֺ���й���ʹ��
        %         AddPairContractToDatabase(obj,pairContractInfo,pairName) %�Խ�access���ݿ⣬������Խ�����Ϣ
        %         pairContractInfo= ExtractPairContractFromDatabase(obj,pairName) %���Խ�access���ݿ���Խ�����Ϣ
    end
    
    methods%callbacks
        funOnRelExecuted(obj) %�������ȳɽ��󴥷��������µ�������
    end
end