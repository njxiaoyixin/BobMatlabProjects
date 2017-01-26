function funOnTrade(obj,varargin)
% persistent iTrade
% Trap event type
switch varargin{end}
    case {'execDetailsEx'}
        contractDetails  = get(varargin{6}.contract);
        executionDetails = get(varargin{6}.execution);
        thisPermId = executionDetails.permId;
        iTrade = numel(obj.Trade)+1;
        if numel(obj.Trade)>0
            for k = 1:numel(obj.Trade)
%                 if strcmpi(obj.Trade(k).other.execId,thisExecId)
                if obj.Trade(k).other.permId == thisPermId
                    iTrade = k;
                    break
                end
            end
        end
        ExecFields = fieldnames(executionDetails);
        obj.Trade(iTrade,1).localSymbol               = contractDetails.localSymbol;
        obj.Trade(iTrade,1).other.contractDetails     = contractDetails;
        for i=1:numel(ExecFields)
            switch lower(ExecFields{i})
                case 'orderid'
                    obj.Trade(iTrade,1).orderId            = executionDetails.orderId;
                case 'time'
                    obj.Trade(iTrade,1).tradeTime          = executionDetails.time;
                case 'cumqty'                    
                    obj.Trade(iTrade,1).thisTradeVolume    = abs(executionDetails.cumQty);
                case 'side'
                    switch upper(executionDetails.side)
                        case 'BOT'
                            obj.Trade(iTrade,1).isBuy              = 1;
                        case 'SLD'
                            obj.Trade(iTrade,1).isBuy              = 0;
                    end
                case 'avgprice'
                    obj.Trade(iTrade,1).thisTradePrice     = executionDetails.avgPrice;
                otherwise
                    obj.Trade(iTrade,1).other.(ExecFields{i}) = executionDetails.(ExecFields{i});
            end
        end
    case {'execDetailsEnd'}
        %         obj.Trade(iTrade,1).other.enddetails = varargin{4};
        %cancel registration
        %                     evtListeners = varargin{1}.eventlisteners;
        %                     i = strcmp(evtListeners(:,1),'execDetailsEx');
        %                     varargin{1}.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
        %                     i = strcmp(evtListeners(:,1),'execDetailsEnd');
        %                     varargin{1}.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
end
end