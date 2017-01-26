classdef TradeBook<handle
   properties
       TimeVec
       PriceVec
       SignalVec
       TransFeeVec
       OrderVec%Record the position in the original TimeVec
       AccountVec
   end
   methods
       function obj=TradeBook()
           obj.TimeVec=[];
           obj.PriceVec=[];
           obj.SignalVec=[];
           obj.TransFeeVec=[];
           obj.OrderVec=[];
           obj.AccountVec=[];
       end
       
       function AddEntry(obj,time,price,positionChange,transFee,order,account)
           if nargin <7
               account=1;
           end
           if nargin<6
               order=1;
           end
           obj.TimeVec=[obj.TimeVec;time];
           obj.PriceVec=[obj.PriceVec;price];
           obj.SignalVec=[obj.SignalVec;positionChange];
           obj.TransFeeVec=[obj.TransFeeVec;transFee];
           obj.OrderVec=[obj.OrderVec,order];
           obj.AccountVec=[obj.AccountVec;account];
       end
   end
end