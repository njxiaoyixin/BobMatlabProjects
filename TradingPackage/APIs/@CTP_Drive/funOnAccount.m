function funOnAccount(obj,varargin)
if isempty(obj.Account)
    obj.Account = BaseAccount;
end
obj.Account.preBalance = varargin{3};
obj.Account.balance = varargin{4};
obj.Account.available = varargin{5};
obj.Account.commission =varargin{6};
obj.Account.frozenCommission = varargin{7};
obj.Account.margin =varargin{8};
obj.Account.frozenMargin=varargin{9};
obj.Account.realizedPNL=varargin{10};
obj.Account.positionPNL= varargin{11};
%     obj.Account = struct('preBalance',varargin{3},'balance',varargin{4},'available',varargin{5},...
%         'commision',varargin{6},'frozenCommision',varargin{7},'margin',varargin{8},'frozenMargin',varargin{9},...
%         'closeProfit',varargin{10},'positionProfit',varargin{11});
end