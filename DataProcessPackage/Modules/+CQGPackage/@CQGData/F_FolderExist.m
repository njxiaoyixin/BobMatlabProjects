function [ExistFlag,Dir,DateDir] = F_FolderExist(~,Date,Exchange,DataSource)
% �жϣ�ĳһ�죩��Ӧ�ģ���Ӧ�����������ļ���·���Ƿ����
YearFolder  = datestr(Date,'yyyy');
DateFolder  = datestr(Date,'yyyymmdd');
Dir=[DataSource,'\',YearFolder,'\',DateFolder,'\',Exchange];
DateDir = [DataSource,'\',YearFolder,'\',DateFolder];
if exist(Dir,'dir')
    ExistFlag=1;
else
    ExistFlag=0;
end
end