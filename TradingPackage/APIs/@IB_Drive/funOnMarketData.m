function funOnMarketData(obj,varargin)
data = obj.MarketData;

% Get ticker request ID's
tickerID = obj.TickerId;

% Process event based on identifier
switch varargin{end}
  
  case 'tickSize'
    
    % Get table index
    tInd = find(varargin{6}.id == tickerID);
    if isempty(tInd)
        return
    end
    switch varargin{6}.tickType
      case 0
        % BID SIZE
        data(tInd,1).bidSize = varargin{6}.size;
      case 3
        % ASK SIZE
        data(tInd,1).askSize = varargin{6}.size;
      case 5
        % LAST SIZE
        data(tInd,1).lastSize = varargin{6}.size;
      case 8
        % VOLUME
        data(tInd,1).volume = varargin{6}.size;
    end
    data(tInd,1).updateTime = datestr(now,'yyyy-mm-dd HH:MM:SS');
    
  case 'tickString'
    
    switch varargin{6}.tickType
      
      case 45
        % Display current time
    
        % IB base date is 01/01/1970
        dateEpoch = datenum('01-Jan-1970');
    
        % Convert IB current time to MATLAB date number
        currentTime = datestr(dateEpoch + str2double(varargin{6}.value)/(24*60*60));
%         data(:,1).updateTime = currentTime;
%         set(findobj('Tag','IBStreamingDataWorkflow'),'Name',currentTime)
    end
    
  case 'tickPrice'
    
    % Get table index
    tInd = find(varargin{7}.id == tickerID);
    if isempty(tInd)
        return
    end
    switch varargin{7}.tickType
      case 1
        % BID PRICE
        data(tInd,1).bidPrice = varargin{7}.price;
      case 2
        % ASK PRICE
        data(tInd,1).askPrice = varargin{7}.price;
      case 4
        % LAST PRICE
        data(tInd,1).lastPrice = varargin{7}.price;
    end
    data(tInd,1).updateTime = datestr(now,'yyyy-mm-dd HH:MM:SS');
end
obj.MarketData = data;