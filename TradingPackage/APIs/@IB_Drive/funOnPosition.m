function funOnPosition(obj,varargin)      % 当持仓数量发生变化时

% disp(datestr(now))

iPosition = numel(obj.Position)+1 ;

% Trap event type
switch varargin{end}
    case {'updatePortfolioEx'}
        thisConId = varargin{11}.contract.conId;
        if numel(obj.Position)>0
            for k = 1:numel(obj.Position)
                if obj.Position(k).contractDetails.conId==thisConId
                    iPosition = k;
                    break
                end
            end
        end
        %         PositionFields = fieldnames(varargin{11});
        obj.Position(iPosition,1).contractDetails = get(varargin{11}.contract);
        obj.Position(iPosition,1).other.type   = varargin{11}.Type;
        obj.Position(iPosition,1).other.source = varargin{11}.Source;
        obj.Position(iPosition,1).other.marketPrice = varargin{11}.marketPrice;
        obj.Position(iPosition,1).other.accountName = varargin{11}.accountName;
        
        obj.Position(iPosition,1).localSymbol       = obj.Position(iPosition,1).contractDetails.localSymbol;
        obj.Position(iPosition,1).isLong            = varargin{11}.position>0;
        obj.Position(iPosition,1).volume            = abs(varargin{11}.position);
        obj.Position(iPosition,1).realizedPNL       = varargin{11}.realizedPNL;
        obj.Position(iPosition,1).positionPNL       = varargin{11}.unrealizedPNL;
        obj.Position(iPosition,1).unrealizedPNL     = varargin{11}.unrealizedPNL;
        obj.Position(iPosition,1).avgPositionPrice  = varargin{11}.averageCost;
        obj.Position(iPosition,1).avgOpenPrice      = varargin{11}.averageCost;
        %
        if numel(obj.Contract)>0
            currentConId = arrayfun(@(x)obj.Contract(x).other.contractDetails.conId,1:numel(obj.Contract));
            obj.Position(iPosition,1).contractId = find(currentConId==thisConId);
        end
        
        % 寻找ContractId里面是否有对应的Position，如果有，则订阅行情，如果没有，则添加Contract并订阅行情
        thisLocalSymbol = obj.Position(iPosition,1).localSymbol;
        contractId = [];
        for i=1:numel(obj.Contract)
            if strcmpi(obj.Contract(i).localSymbol,thisLocalSymbol)
                contractId = i;
                break
            end
        end
        if isempty(contractId)
            thisContractInfo = obj.Position(iPosition,1).contractDetails;
            disp([thisLocalSymbol,' not in the Contract Set, Adding New...'])
            try
            contractId = obj.AddContract(thisContractInfo);
            obj.GetMarketData(contractId);
            catch Err
                assignin('base','Err',Err)
            end
        end
        obj.Position(iPosition,1).contractId = contractId;
        
        %         for i = 1:length(PositionFields)
        %             switch PositionFields{i}
        %                 case 'contract'
        %                     obj.Position(iPosition,1).(PositionFields{i}) = get(varargin{11}.(PositionFields{i}));
        %                 otherwise
        %                     obj.Position(iPosition,1).(PositionFields{i}) = varargin{11}.(PositionFields{i});
        %             end
        %         end
        
        %         assignin('base','ibBuiltInPositionData',ibBuiltInPositionData);
        %         obj.Position = ibBuiltInPositionData;
        
    case {'accountDownloadEnd'}
        % 第一次查询完成后，会产生此事件
        %         obj.Position = ibBuiltInPositionData;
        %         assignin('base','ibBuiltInPositionData',ibBuiltInPositionData);
        
        % Clear persistent variables and event listeners
%         clear iPosition
        %Cancel Registration
        %         evtListeners = varargin{1}.eventlisteners;
        %         i = strcmp(evtListeners(:,1),'updatePositionEx');
        %         varargin{1}.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
        %         i = strcmp(evtListeners(:,1),'accountDownloadEnd');
        %         varargin{1}.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
        %         varargin{end}.DataRequest = false; %#ok
end
drawnow
end