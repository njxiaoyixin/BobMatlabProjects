classdef BaseDriveData < handle
    properties(AbortSet, SetObservable) %当需要设置的值与当前值一致的时候不触发相应的PostSet以及PreSet事件
        LoginId                         % 连接代号，CTP为CTPCom object， IB为IB Object
        Contract@BaseContract           % 合约基本信息，第一列为合约编号，第二列为合约基本信息，如果是IB，则第三列为ibContract Object
        ConnStatus                      % 与交易端连接状态
        Busy
        TimeLog@BaseTimeLog
        SystemSwitch@BaseSystemSwitch   % 交易系统开关（内含是否交易isTrade）
    end
    
    methods
        function obj=BaseDriveData
            obj.TimeLog = BaseTimeLog;
            obj.SystemSwitch = BaseSystemSwitch;
        end
    end
end