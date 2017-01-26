classdef MyProject < handle
   properties (Constant)
      ProjectInfo = MyProject; 
   end
   properties
      Date
      Department
      ProjectNumber
   end
   methods (Access = private)
      function obj = MyProject
         obj.Date = datestr(clock);
         obj.Department = 'Engineering';
         obj.ProjectNumber = 'P29.367';
      end
   end
end