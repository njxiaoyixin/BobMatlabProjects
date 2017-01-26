classdef DBTrader < handle
   properties
       TradeObj @ BaseTradeObj
       Strategy %@ BaseTrategy
       Listener
       GlobalParam
       LoginParam
   end
    
   methods
       function obj=DBTrader(Dir)
           % ����Ĭ��Ŀ¼/���ļ�����Ŀ¼
           if nargin<1
               p1 = mfilename('fullpath');
               i=strfind(p1,'\');
               Dir=p1(1:i(end-1));
           end
           obj.GlobalParam.Dir = Dir;
           addpath E:\CGTrader\AutoTrade
       end
       
       function tradeObjId = AddTradeObj(obj,TradeObjType,TradeObjName)
           % TradeObjType ����Ϊ CTP����IB
          
           if nargin >=3
               thisTradeObjName = TradeObjName;
           else
               thisTradeObjName = [];
           end
           
           if nargin >=2
               thisTradeObjType = upper(TradeObjType);
           else
               error('Please Input TradeObj Type!')
           end
           currentTradeObjName = {obj.TradeObj.name};
           currentTradeObjType = {obj.TradeObj.type};
           %��Name��Ϊ���֣������ظ����TradeObj
           Ind = strcmpi(thisTradeObjName,currentTradeObjName) & strcmpi(thisTradeObjType,currentTradeObjType);
           if any(Ind)
               tradeObjId = find(Ind,1);
                return
           else
               NumTradeObj = numel(obj.TradeObj);
               tradeObjId  = NumTradeObj+1;
           end
           obj.TradeObj(tradeObjId,1).name = thisTradeObjName;
           obj.TradeObj(tradeObjId,1).type = thisTradeObjType;
           obj.TradeObj(tradeObjId,1).obj = eval([upper(obj.TradeObj(tradeObjId).type),'_Drive']);
           obj.LoginParam{tradeObjId,1} = [];
       end
       
       function PresetLoginParam(obj,TradeObjNum,LoginParam)
            obj.LoginParam{TradeObjNum} = LoginParam;
       end
        
       function LoginTradeObj(obj,tradeObjIdVec)
            %�����ɸĽ�����ÿ��TradeObj���õ����ĵ�½����
            if nargin < 2
               tradeObjIdVec = 1:numel(obj.TradeObj);
            end
            for tradeObjId=tradeObjIdVec
                if ~isempty(obj.LoginParam{tradeObjId})
                    s = obj.LoginParam{tradeObjId};
                    obj.TradeObj(tradeObjId).obj.LoginTrade(s);
                else
                    %Ĭ�ϵ�½����
                    obj.TradeObj(tradeObjId).obj.LoginTrade;
                end
                obj.TradeObj(tradeObjId).obj.InitializeDrive;
            end
       end
       
       function LogoutTradeObj(obj,tradeObjIdVec)
           if nargin < 2
               tradeObjIdVec = 1:numel(obj.TradeObj);
           end
           for tradeObjId=tradeObjIdVec
               obj.TradeObj(tradeObjId).obj.LogoutTrade;
           end
       end
       
       InitializeDBTrader(obj) 
       
       function StartRiskEngine(obj,tradeObjId)
           listenerId = numel(obj.Listener)+1;
           obj.Listener(listenerId).name        = 'Risk';
           obj.Listener(listenerId).listenerObj = addlistener(obj.TradeObj(tradeObjId).obj,'Account','PostSet',@(src,evnt) funOnRisk(obj,src,evnt));
       end
       
       function contractId = AddContract(obj,contractInfo,tradeObjIdVec)
           if nargin < 2
               tradeObjIdVec = 1:numel(obj.TradeObj);
           end
           for tradeObjId=tradeObjIdVec
               contractId = obj.TradeObj(tradeObjId).obj.AddContract(contractInfo);
           end
       end
       
       function GetMarketData(obj,tradeObjIdVec)
           if nargin < 2
               tradeObjIdVec = 1:numel(obj.TradeObj);
           end
           for tradeObjId=tradeObjIdVec
               obj.TradeObj(tradeObjId).obj.GetMarketData;
           end
       end
       
       function listenerId = DuplicateMD(obj,sourceTradeObjId,targetTradeObjId,sourceContractId,targetContractId)
           listenerId = numel(obj.Listener)+1;
           if nargin < 4
               obj.Listener(listenerId).listenerObj = addlistener(obj.TradeObj(sourceTradeObjId).obj,'MarketData','PostSet',@(src,evnt) DuplicateMD_CallBack(obj,sourceTradeObjId,targetTradeObjId,src,evnt));
           else
               obj.Listener(listenerId).listenerObj = addlistener(obj.TradeObj(sourceTradeObjId).obj.MarketData(sourceContractId),'updateTime','PostSet',@(src,evnt) DuplicateMD_CallBack(obj,sourceTradeObjId,targetTradeObjId,sourceContractId,targetContractId,src,evnt));
           end
           %��ĳһ��TradeObj���ĵ����鸴�Ƶ���һ��TradeObj�ϣ��������뽻�׵�ͨ���ֿ���
           meta(1) = metaclass(obj.TradeObj(sourceTradeObjId).obj);
           meta(2) = metaclass(obj.TradeObj(targetTradeObjId).obj);
           obj.Listener(listenerId).desc = ['Copy MarketData from TradeObj ',num2str(sourceTradeObjId),'-',meta(1).Name,' to TradeObj ',num2str(targetTradeObjId),'-',meta(2).Name];
       end
       
       function draftId = AddOrder(obj,tradeObjId,contractId,orderInfo)
           draftId = obj.TradeObj(tradeObjId).obj.AddOrder(contractId,orderInfo);
       end
       
       function TransmitOrder(obj,tradeObjId,draftId)
           obj.TradeObj(tradeObjId).obj.TransmitOrder(draftId);
       end
       
       function [cancelId,remark]=CancelDraftOrder(obj,tradeObjId,draftId)
           [cancelId,remark] = obj.TradeObj(tradeObjId).obj.CancelDraftOrder(draftId);
       end
       
       function cancelId = CancelOrder(obj,tradeObjId,orderId)
           [cancelId] = obj.TradeObj(tradeObjId).obj.CancelOrder(orderId);
       end
       
       function Clear(obj,tradeObjId,localSymbol)
           obj.TradeObj(tradeObjId).obj.Clear(localSymbol);
       end
       
       function AllClear(obj,tradeObjIdVec)
           if nargin<2
               tradeObjIdVec = 1:numel(obj.TradeObj);
           end
           for tradeObjId=tradeObjIdVec
               obj.TradeObj(tradeObjId).obj.AllClear;
           end
       end

       function strategyId = AddStrategy(obj,strategyType,strategyName)
           if nargin<2
               strategyName = strategyType;
           end
           strategyId = numel(obj.Strategy)+1;
           obj.Strategy(strategyId).type         = strategyType;
           obj.Strategy(strategyId).name         = strategyName;
           obj.Strategy(strategyId).Strategy.Obj = eval([strategyType,'(obj.GlobalParam.Dir,obj)']);
       end
       
       function SetStrategyParam(obj,strategyId,Param)
           obj.Strategy(strategyId).obj.Param = Param;
       end
       
       function StartStrategy(obj,strategyIdVec)
            if nargin < 2
               strategyIdVec = 1:numel(obj.Strategy);
            end
            for strategyId=1:numel(strategyIdVec)
                obj.Strategy(strategyId).obj.StartStrategy;
            end
       end
       
       function StopStrategy(obj,strategyIdVec)
           if nargin < 2
               strategyIdVec = 1:numel(obj.Strategy);
           end
           for strategyId=1:numel(strategyIdVec)
               obj.Strategy(strategyId).obj.StopStrategy;
           end
       end
       
       function StopSystem(obj,tradeObjIdVec)
           if nargin < 2
               tradeObjIdVec = 1:numel(obj.TradeObj);
           end
           for tradeObjId=1:numel(tradeObjIdVec)
               obj.TradeObj(tradeObjId).obj.StopSystem;
           end
       end
   end
   
   methods (Access = private)  %Callbacks
       function DuplicateMD_CallBack(obj,sourceTradeObjId,targetTradeObjId,varargin)
           obj.TradeObj(targetTradeObjId).obj.MarketData = obj.TradeObj(sourceTradeObjId).obj.MarketData;
       end
       function DuplicateMD_Contract_CallBack(obj,sourceTradeObjId,targetTradeObjId,sourceContractId,targetContractId,varargin)
           obj.TradeObj(targetTradeObjId).obj.MarketData(targetContractId) = obj.TradeObj(sourceTradeObjId).obj.MarketData(sourceContractId);
       end
       funOnRisk(obj,varargin)
   end
end