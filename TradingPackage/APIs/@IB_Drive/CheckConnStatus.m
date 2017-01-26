function CheckConnStatus(obj)
%status 表示连接状态
% 0表示断线，1表示连接，2表示已连接，但是包含其他内容
if evalin('base','exist(''ibBuiltInErrMsg'',''var'')')
    x=evalin('base','ibBuiltInErrMsg');
    if regexp(x,'OK')
        obj.ConnStatus = 1;
        disp('Connection OK.')
    else
        obj.ConnStatus = 2;
        disp(x)
    end
else
    obj.ConnStatus = 0;
    disp('DisConnceted.')
end
end