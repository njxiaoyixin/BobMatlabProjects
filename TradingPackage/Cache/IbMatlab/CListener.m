classdef CListener < handle
    
    properties
       symbol % watch only this symbol
    end
    
       
    properties (Hidden)
       Listener 
       ListenForObj
	   ListenForName
    end
    
    methods
        function obj = CListener(symbol)
            obj.symbol = symbol;
        end
        
        function startListening(obj, targetObj, targetName)
            obj.ListenForObj = targetObj;
            obj.ListenForName = targetName;

            disp(['Viewer will attempt to listen for ' obj.ListenForName ' from ' class(obj.ListenForObj)]);

            obj.Listener = addlistener(obj.ListenForObj,obj.ListenForName,@(src,evnt)handleEvent(obj,src,evnt));
        end
        function stopListening(obj)
			delete(obj.Listener);
        end
        
        function handleEvent(obj, src, event)
            
           if ~strcmp(event.data.symbol, obj.symbol)
               return % listen only for updates of own symbol
           end
           
           fprintf('(%s) %s traded @ %2.2f \n', datestr(event.data.lastUpdate),obj.symbol, event.data.last);
          
        end
       
    end
    
end