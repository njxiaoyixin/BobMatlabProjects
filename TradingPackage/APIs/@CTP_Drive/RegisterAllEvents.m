function RegisterAllEvents(obj)
%Event Registration
obj.LoginId.registerevent({'OnInitFinished' @(varargin) obj.funOnInitFinished(varargin{:})});
%Event: Market Data,Trade Connection & disconnection;
obj.LoginId.registerevent({'OnMDConnected' @(varargin) obj.funOnMDConnected(varargin{:})});
obj.LoginId.registerevent({'OnMDDisconnected' @(varargin) obj.funOnMDDisconnected(varargin{:})});
obj.LoginId.registerevent({'OnTradeConnected' @(varargin) obj.funOnOnTradeConnected(varargin{:})});%             obj.LoginId.registerevent({'OnTradeDisconnected' obj.Callbacks('funOnTradeDisconnected')});

%Event: Market Data receiving and Account information
obj.LoginId.registerevent({'OnMarketData' @(varargin) obj.funOnMarketData(varargin{:})});
obj.LoginId.registerevent({'OnAccount' @(varargin) obj.funOnAccount(varargin{:})});

%Event: %OnOrder,OnTrade,OnOrderCanceled,OnOrderFinished,OnOrderActionFailed
obj.LoginId.registerevent({'OnOrder' @(varargin) obj.funOnOrder(varargin{:})});
obj.LoginId.registerevent({'OnTrade' @(varargin) obj.funOnTrade(varargin{:})});
obj.LoginId.registerevent({'OnPosition' @(varargin) obj.funOnPosition(varargin{:})});
obj.LoginId.registerevent({'OnOrderCanceled' @(varargin) obj.funOnOrderCanceled(varargin{:})});
obj.LoginId.registerevent({'OnOrderFinished' @(varargin) obj.funOnOrderFinished(varargin{:})});
obj.LoginId.registerevent({'OnOrderActionFailed' @(varargin) obj.funOnOrderActionFailed(varargin{:})});
disp([datestr(now,'HH:MM:SS'),'---Events Registering Succeeded.---'])
end