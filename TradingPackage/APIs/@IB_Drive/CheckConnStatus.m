function CheckConnStatus(obj)
%status ��ʾ����״̬
% 0��ʾ���ߣ�1��ʾ���ӣ�2��ʾ�����ӣ����ǰ�����������
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