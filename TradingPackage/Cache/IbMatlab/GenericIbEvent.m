classdef GenericIbEvent < event.EventData
% This class provides a temporary fix for passing the new event object
% to the listeners. I think we can come up with a better method in future.
	
   properties
      data
   end

   methods
      function d = GenericIbEvent(e)
         d.data = e;
      end
   end
end

%% Leptokurtosis.com IbMatlab
% $Rev: 266 $ 
% $Date: 2009-01-13 16:09:57 +0000(Tue, 13 Jan 2009)$