function [ExistFlag,Dir,DateDir] = F_FolderExist(~,Date,Exchange,DataSource)
% �жϣ�ĳһ�죩��Ӧ�ģ���Ӧ�����������ļ���·���Ƿ����
% ע��2012��֮ǰ�����ݴ�Ź���ͬ

YearFolder  = datestr(Date,'yyyy');
% MonthFolder = datestr(Date,'yyyymm');
DateFolder  = datestr(Date,'yyyymmdd');
% Dir1=[DataSource,'\',YearFolder];
% if year(Date)<=2012
%     Dir=[DataSource,'\',YearFolder,'\',MonthFolder,'\',Exchange,'\',DateFolder];
% else
Dir      = [DataSource,'\',YearFolder,'\',DateFolder,'\',Exchange];
DateDir = [DataSource,'\',YearFolder,'\',DateFolder];
% end
if exist(Dir,'dir')
    ExistFlag=1;
else
    ExistFlag=0;
end
end