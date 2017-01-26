classdef ClearBook < handle
    properties
        TimeVec%Closing time of positions
        PositionVec
        RetVec
        GainVec
        TransFeeVec
        CostVec
        OrderVec
    end
    
    methods
        function obj=ClearBook()
            obj.TimeVec=[];
            obj.PositionVec=[];
            obj.RetVec=[];
            obj.GainVec=[];
            obj.TransFeeVec=[];
            obj.CostVec=[];
            obj.OrderVec=[];
        end
        
        function AddEntry(obj,time,position,ret,gain,transFee,Cost,order)
            if nargin<7
                order=1;
            end
            obj.TimeVec=[obj.TimeVec;time];
            obj.PositionVec=[obj.PositionVec;position];
            obj.RetVec=[obj.RetVec;ret];
            obj.GainVec=[obj.GainVec;gain];
            obj.TransFeeVec=[obj.TransFeeVec;transFee];
            obj.OrderVec=[obj.OrderVec;order];
            obj.CostVec=[obj.CostVec;Cost];
        end
    end
end