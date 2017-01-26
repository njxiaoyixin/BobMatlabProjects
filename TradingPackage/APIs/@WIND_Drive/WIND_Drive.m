classdef WIND_Drive < BaseQuoteDrive
    properties
        
    end
    
    methods
        function obj = WIND_Drive()
            
        end
    end
    
    methods (Access = protected)
        funOnMarketData(obj,varargin)  % 当行情发生变化时的操作
        AssignMarketData(obj,w_wsq_data,w_wsq_codes,w_wsq_fields,w_wsq_times)
    end
    
    methods(Static = true,Access = private)
        [InternalFields,WindFields] = GenerateFields()
    end
end