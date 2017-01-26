function funOnAccount(obj,varargin)
%IBBUILTINACCOUNTDATAEVENTHANDLER Interactive Brokers' Trader Workstation built in account data event handler.

% persistent ibBuiltInAccountData

% Trap event type
if isempty(obj.Account)
    obj.Account = BaseAccount;
end
switch varargin{end}
    
    case {'updateAccountTime'}
        obj.Account.updateTime = datestr(now);
        % Return data to base workspace
        %     assignin('base','ibBuiltInAccountData',ibBuiltInAccountData);
        %     clear ibBuiltInAccountData
        %     evtListeners = varargin{1}.eventlisteners;
        %     i = strcmp(evtListeners(:,1),'updateAccountValue');
        %     varargin{1}.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
        %     i = strcmp(evtListeners(:,1),'updateAccountTime');
        %     varargin{1}.unregisterevent({evtListeners{i,1} evtListeners{i,2}});
        %     varargin{end}.DataRequest = false; %#ok
        
    case {'updateAccountValue'}
        
        sFieldName = varargin{3};
        sFieldName(sFieldName == '-' | sFieldName == '+') = '_';
        switch upper(sFieldName)
            case 'ACCOUNTTYPE'
                obj.Account.other.accountType = varargin{4};
            case 'ACCOUNTCODE'
                obj.Account.other.accountCode = varargin{4};
            case 'AVAILABLEFUNDS'
                obj.Account.available = varargin{4};
            case 'BUYINGPOWER'
                obj.Account.other.buyingPower = varargin{4};
            case 'CURRENCY'
                obj.Account.other.currency = varargin{4};
            case 'FULLMAINTMARGINREQ'
                obj.Account.margin = varargin{4};
            case 'NETLIQUIDATION'
                obj.Account.balance = varargin{4};
            case 'REALIZEDPNL'
                obj.Account.realizedPNL = varargin{4};
            case 'UNREALIZEDPNL'
                obj.Account.unrealizedPNL = varargin{4};
            otherwise
                obj.Account.other.(sFieldName) =varargin{4};
        end
        % Return data to base workspace
        %     assignin('base','ibBuiltInAccountData',ibBuiltInAccountData);
        
end