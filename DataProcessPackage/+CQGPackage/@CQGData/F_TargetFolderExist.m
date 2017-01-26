function [ExistFlag,Dir] = F_TargetFolderExist(~,Date,Exchange,DataSource)
% �жϣ�ĳһ�죩��Ӧ�ģ���Ӧ�����������ļ���·���Ƿ����

YearFolder  = datestr(Date,'yyyy');
MonthFolder  = datestr(Date,'yyyymm');
Dir=[DataSource,'\',YearFolder,'\',MonthFolder];
if exist(Dir,'dir')
    ExistFlag=1;
else
    ExistFlag=0;
end
end