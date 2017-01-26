function [ExistFlag,Dir] = F_TargetFolderExist(~,Date,Exchange,DataSource)
% 判断（某一天）对应的（相应交易所）的文件夹路径是否存在

YearFolder  = datestr(Date,'yyyy');
MonthFolder  = datestr(Date,'yyyymm');
Dir=[DataSource,'\',YearFolder,'\',MonthFolder];
if exist(Dir,'dir')
    ExistFlag=1;
else
    ExistFlag=0;
end
end