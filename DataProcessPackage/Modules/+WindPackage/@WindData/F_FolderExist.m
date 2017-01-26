function [ExistFlag,Dir,DateDir] = F_FolderExist(~,Date,Exchange,DataSource)
% 判断（某一天）对应的（相应交易所）的文件夹路径是否存在
% 注：2012年之前的数据存放规则不同

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