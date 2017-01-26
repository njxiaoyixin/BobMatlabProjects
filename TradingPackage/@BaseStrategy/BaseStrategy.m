classdef BaseStrategy < handle
    properties(AbortSet, SetObservable)
        DBTrader
        TradeCondition
        Dir
        Param
        Listener
        Timer
        MarketData %��ȡ��MarketData
        StrategyStatus
        TradeTimeStatus
    end
    properties(Hidden)
        InitFinished=0
    end
    methods
        function obj = BaseStrategy(Dir,DBTrader)
            if nargin>=1
                obj.Dir = Dir;
            end
            if nargin >=2
                obj.DBTrader = DBTrader;
            end
        end
        
        SetParam(obj)
        
        % Ϊ���Զ���ĳ����Լ�����飨���TradeObjδ���ж��ģ��Զ����TradeObj���ģ�
        function [listenerId,contractId] = SubscribeMarketData(obj,tradeObjId,varargin)
            % varargin������ʽ: 'contractId',contractId
            %                   'contractInfo',contractInfo
            if strcmpi(varargin{1},'contractId')
                contractId = varargin{2};
            elseif strcmpi(varargin{1},'contractInfo')
                contractId = obj.DBTrader.AddContract(contractInfo,tradeObjId);
                obj.DBTrader.TradeObj(tradeObjId).obj.GetMarketData(contractId)
            end
            listenerId = numel(obj.Listener)+1;
            obj.Listener(listenerId).obj = addlistener(obj.DBTrader.TradeObj(tradeObjId).obj,'MarketData','PostSet',@(src,evnt) SubscribeStrategyMD_CallBack(obj,tradeObjId,contractId,src,evnt));
            obj.Listener(listenerId).desc  = ['Subscribe ',obj.DBTrader.TradeObj(tradeObjId).obj.ContractSet(contractId).localSymbol, ' MarketData from TradeObj ',tradeObjId];
        end
        
        InitializeStrategy(obj)
        StartStrategy(obj)
        StopStrategy(obj)
        StopSystem(obj)
        Result = CalcStrategyResult(obj)
    end
    
    methods(Access = private)
        function SubscribeStrategyMD_CallBack(obj,tradeObjId,contractId,varargin)
            if numel(obj.DBTrader.TradeObj(tradeObjId).obj.MarketData)>=contractId
                obj.MarketData = obj.DBTrader.TradeObj(tradeObjId).obj.MarketData(contractId);
            end
        end
        funOnStrategyMarketData(obj,varargin)
    end
end