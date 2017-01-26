classdef  BaseDriveMethod < handle
    methods %基础模块
        function obj = BaseDriveMethod
        end
        function SetProperties(obj, varargin )
            %PropertyNames需要是一列Cell，每个Cell里面有一个Property的名字（当只有一个Property的时候可以使用向量）
            %PropertyValues 需要是一列Cell，每个Cell对应的Property的值(当只有一个Property的时候可以使用向量)
            argin=varargin;
            if numel(argin)>0 && mod(numel(argin),2)==0
                for i=2:2:numel(argin)
                    obj.(argin{i-1})=argin{i};
                end
            end
        end
        function Output=GetProperties(obj,varargin)
            argin=varargin;
            Output=cell(numel(argin));
            if numel(argin)>1
                for i=1:(numel(argin))
                    Output{i}=obj.(argin{i});
                end
            elseif numel(argin)==1
                Output=obj.(argin{1});
            end
        end
    end
    methods % 跟交易和行情相关的通用函数
        LoginId = LoginTrade(obj,LoginParam)
        Status  = LogoutTrade(obj)
        InitializeDrive(obj)
        status  = CheckConnStatus(obj)
        contractId = AddContract(obj,contractInfo)
        StopSystem(obj) %强制撤单，停止下单，并退出登陆
    end
end