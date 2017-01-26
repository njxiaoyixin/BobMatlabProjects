classdef CTws  < handle
    properties 
        debug = false;
        
    end % public properties
    
    properties (SetAccess = private)
        symbols
        logfile 
        symbolData   % containers for tws data
        nextValidOrderId
   
    end % private properties
    properties (Hidden)
        tws
        f
        eventlistener
        requestIds
    end
    
    properties (Hidden, Constant)
       timeBase = datenum('01-Jan-1970'); 
    end
        
    events
		trade
	end    
    
    
    methods 
        function obj = CTws
        % constructor    
           obj.f = figure(999); 
           set(obj.f,'Visible','off');
           obj.tws = actxcontrol('TWS.TwsCtrl.1',[0 0 0 0],obj.f);
           
        end
        
        function connect(obj)
          % connect to tws and init event listener
           obj.tws.connect('', 7496, 101); 
           disp('Connecting to TWS...');
           obj.eventlistener = @obj.twsevent;
           obj.tws.registerevent(obj.eventlistener);
        end
        
        function subscribe(obj,symbol, varargin)
        % add subscription to a symbol
        % optional arguments: secType, exchange
           if isempty(varargin)
              secType = 'STK';
              exchange = 'SMART';
           else
              secType = varargin{1};
              exchange = varargin{2};
           end
           
           % check if already subscribed to this symbol
           subscribed = ~isempty(obj.getIdx(symbol));
           
           if subscribed
               warning('Duplicate subscription');
               return
           end
           
           iNewSubs = length(obj.symbols)+1;
           obj.symbols{iNewSubs} = symbol;
           obj.symbolData{iNewSubs} = CSymbolData(symbol);
           obj.requestIds(iNewSubs) = symbol2id(symbol);

           % now subscribe
           contract = obj.tws.createContract();
           contract.secType = secType;
           contract.exchange = exchange;
           contract.currency = 'USD';
           contract.symbol = symbol;
           requestId = obj.requestIds(iNewSubs);

           obj.logData(sprintf('subscribing to %s \n',contract.symbol));
           %tws.reqRealTimeBarsEx(requestId,contract,5,'MIDPOINT',0);
           obj.tws.reqMktDataEx(requestId,contract,'',0);
            
        end
        
        function unsubscribe(obj, symbol)
           obj.logData(sprintf('Cancelling subscription to %s \n',symbol)); 
           idx = obj.getIdx(symbol);
           obj.tws.cancelMktData(obj.requestIds(idx));
           obj.requestIds(idx) = [];
           obj.symbols(idx) = [];
           obj.symbolData(idx) = [];
           
        end
        
        function show(obj, symbol)
            % print current symbol data
            idx = obj.getIdx(symbol);
            if isempty(idx)
                disp('Symbol not found');
                return;
            end
            
            fprintf('Symbol:%s LastTrade:%2.2f time:%s \n', obj.symbolData{idx}.symbol,...
            obj.symbolData{idx}.last, datestr(obj.symbolData{idx}.lastUpdate));
            
        end
        
        function idx = getIdx(obj, symbol)
            % get subscription index.
            idx = find(strcmp(obj.symbols,strtrim(symbol))==1);
        end
        
        function logData(obj,s)
            % write data to file & screen. Skip file logging if no file has
            % been defined

            str = sprintf('[%s] %s\n',datestr(now,'yyyy-mm-dd HH:MM:SS'), s);
            fprintf(str); % show on screen

            if isempty(obj.logfile)
                return
            end

            fid = fopen(twsData.logfile,'a');

            fprintf(fid,str);
            fclose(fid);
        end
        
       
        function twsevent(obj, varargin)
        % callback function for tws ActiveX
            for i = 2:length(varargin)
                if isstruct(varargin{i})
                    d = varargin{i};
                end
            end

            if (obj.debug) % show tws data if debugging
                disp(d);
            end

            switch d.Type
                case 'tickPrice'
                    idx = find(obj.requestIds==d.id);
                    switch d.tickType
                        case 1
                            obj.symbolData{idx}.bid = d.price;
                        case 2
                             obj.symbolData{idx}.ask = d.price;
                        case 4
                            obj.symbolData{idx}.last = d.price;
                            obj.symbolData{idx}.lastUpdate = now;
                            eData = GenericIbEvent(obj.symbolData{idx});
                            notify(obj,'trade',eData);  % notify listeners
                        case 6
                            obj.symbolData{idx}.high = d.price;
                        case 7
                            obj.symbolData{idx}.low = d.price;
                        case 9
                            obj.symbolData{idx}.close = d.price;
                        case 14
                            obj.symbolData{idx}.open = d.price;
                        otherwise
                            fprintf('Ignoring tick type: %i \n', d.tickType);
                    end

                case 'tickSize'

                case 'tickGeneric'

                case 'tickSnapshotEnd'

                case 'orderStatus'

                case 'errMsg'
                     obj.logData(d.errorMsg);
                case 'connectionClosed'
                     obj.logData('Disconnected.');
                case 'openOrder1'

                case 'openOrder2'

                case 'openOrder4'

                case 'updateAccountValue'
                    
                case 'updatePortfolio'
                
                case 'updateAccountTime'
                
                case 'nextValidId'
                
                case 'permId'

                case 'contractDetailsEx'
                
                case 'contractDetailsEnd'
                
                case 'contractDetails'

                case 'execDetails'

                case 'updateMktDepth'
                
                case 'updateMktDepthL2'

                case 'updateNewsBulletin'

                case 'managedAccounts'

                case 'openOrder3'

                case 'openOrderEnd'

                case 'receiveFA'

                case 'intradayData'

                case 'tickString'

                case 'historicalData'
                
                case 'accountDownloadEnd'
                
                case 'openOrderEx'
                
                case 'execDetailsEx'
                
                case 'updatePortfolioEx'
                
                case 'currentTime' 
                    twsData.time = ogj.timeBase + (d.time/86400);
                    obj.logData(sprintf('Server time : %s ',datestr(twsData.time)));

                case 'realtimeBar'
             
                otherwise
                    obj.logData(sprintf('Unknown event: %s ', d.Type));
            end
        end
        
        function disconnect(obj)
        % execute this before destroying the object for a clean exit
            obj.tws.disconnect;
            release(obj.tws);
            close(obj.f);
        end
        
        function delete(obj)
           disp('deleting tws class...'); 
        end
        
    end % methods
 end % classdef
 
 %-------- utility functions
function id = symbol2id(ticker)
% convert a ticker string to uint32 id
    char_array = unicode2native(ticker);
    l = length(char_array);
    id =uint32(0);

    for i = 1:l 
       b = bitshift(uint32(char_array(i)),8*(i-1));
       id = id+b;

    end
end