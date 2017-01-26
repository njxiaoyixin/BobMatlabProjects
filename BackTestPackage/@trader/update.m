 function update(obj,time,price,i)
            obj.CurrentStatus.RefreshUnrealized(price);
            if isempty(obj.TimeVec)&&nargin>=3
                obj.TimeVec=[obj.TimeVec,time];
                obj.AssetVec=[obj.AssetVec,obj.InitialFund+obj.CurrentStatus.RealizedGain+obj.CurrentStatus.UnrealizedGain];
                obj.RetVec=[obj.RetVec,obj.CurrentStatus.RealizedRet+obj.CurrentStatus.UnrealizedRet];
                obj.PositionVec=[obj.PositionVec,obj.GetPosition()];
            elseif nargin==3&&time~=obj.TimeVec(end)
                obj.TimeVec=[obj.TimeVec,time];
                obj.AssetVec=[obj.AssetVec,obj.InitialFund+obj.CurrentStatus.RealizedGain+obj.CurrentStatus.UnrealizedGain];
                obj.RetVec=[obj.RetVec,obj.CurrentStatus.RealizedRet+obj.CurrentStatus.UnrealizedRet];
                obj.PositionVec=[obj.PositionVec,obj.GetPosition()];
            elseif time==obj.TimeVec(end)
                obj.AssetVec(end)=obj.InitialFund+obj.CurrentStatus.RealizedGain+obj.CurrentStatus.UnrealizedGain;
                obj.RetVec(end)=obj.CurrentStatus.RealizedRet+obj.CurrentStatus.UnrealizedRet;
                obj.PositionVec(end)=obj.GetPosition();
            elseif ~isempty(obj.TimeVec)&&nargin==4
                %                 %                 obj.TimeVec(i)=time;
                %                 obj.AssetVec(i:end)=obj.CurrentStatus.Fund+obj.CurrentStatus.UnrealizedGain;
                %                 %Can be replaced by obj.CurrentStatus.Fund
                %                 obj.RetVec(i:end)=obj.CurrentStatus.RealizedRet+obj.CurrentStatus.UnrealizedRet;
                %                 obj.PositionVec(i:end)=obj.GetPosition();
                %
                obj.AssetVec(i)=obj.CurrentStatus.Fund+obj.CurrentStatus.UnrealizedGain;
                %Can be replaced by obj.CurrentStatus.Fund
                obj.RetVec(i)=obj.CurrentStatus.RealizedRet+obj.CurrentStatus.UnrealizedRet;
                obj.PositionVec(i)=obj.GetPosition();
            else
                error('Not Enough Input!')
            end
        end