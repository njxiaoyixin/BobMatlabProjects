function GetPosition(obj,contractId)%²éÑ¯³Ö²Ö
AccountNumber = obj.account;
try
    %                 AllPosition =portfolio(obj.LoginId,obj.account,@(varargin) obj.funOnPosition(varargin{:}));
    eventNames = {'updatePortfolioEx','accountDownloadEnd'};
    evtListeners = obj.LoginId.Handle.eventlisteners;
    for i = 1:length(eventNames)
        k = strcmp(evtListeners(:,1),eventNames{i});
        if ~any(k) || isempty(k)
            obj.LoginId.Handle.registerevent({eventNames{i},@(varargin)obj.funOnMarketData(varargin{:})});
        end
    end
    obj.LoginId.Handle.reqAccountUpdates(true,AccountNumber)
catch Err
    assignin('base','Err',Err)
    disp(evalin('base','ibBuiltInErrMsg'))
end
%                     AllPosition = portfolio(obj.LoginId,obj.account);
%             if nargin >= 2 && ~isempty(contractId)
%                 Ind = zeros(size(AllPosition))>0;
%                 for i=1:numel(AllPosition)
%                     Ind(i) = strcmpi(AllPosition(i).contract.symbol,obj.Contract(contractId).contractInfo.symbol) && ...
%                         strcmpi(AllPosition(i).contract.expiry,obj.Contract(contractId).contractInfo.expiry);
%                 end
%                 Fields = fieldnames(AllPosition);
%                 Position = struct();
%                 for k=1:numel(Fields)
%                     Position.(Fields{k}) = AllPosition(Ind).(Fields{k});
%                 end
%             else
%                 Position = AllPosition;
%             end
end