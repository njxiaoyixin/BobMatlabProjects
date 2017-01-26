classdef  BaseDriveMethod < handle
    methods %����ģ��
        function obj = BaseDriveMethod
        end
        function SetProperties(obj, varargin )
            %PropertyNames��Ҫ��һ��Cell��ÿ��Cell������һ��Property�����֣���ֻ��һ��Property��ʱ�����ʹ��������
            %PropertyValues ��Ҫ��һ��Cell��ÿ��Cell��Ӧ��Property��ֵ(��ֻ��һ��Property��ʱ�����ʹ������)
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
    methods % �����׺�������ص�ͨ�ú���
        LoginId = LoginTrade(obj,LoginParam)
        Status  = LogoutTrade(obj)
        InitializeDrive(obj)
        status  = CheckConnStatus(obj)
        contractId = AddContract(obj,contractInfo)
        StopSystem(obj) %ǿ�Ƴ�����ֹͣ�µ������˳���½
    end
end