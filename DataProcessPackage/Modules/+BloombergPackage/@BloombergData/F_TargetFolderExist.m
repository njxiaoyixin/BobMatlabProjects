function [ExistFlag,Dir] = F_TargetFolderExist(~,Date,Exchange,DataSource)
% �жϣ�ĳһ�죩��Ӧ�ģ���Ӧ�����������ļ���·���Ƿ����
YearFolder  = datestr(Date,'yyyy');
DateFolder  = datestr(Date,'yyyymmdd');
Dir=[DataSource,'\',YearFolder,'\',DateFolder,'\',Exchange];
if exist(Dir,'dir')
    ExistFlag=1;
else
    ExistFlag=0;
end
end