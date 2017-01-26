% function PathSetting_DataProcess()
p1 = mfilename('fullpath');
i=strfind(p1,'\');
p1=p1(1:i(end));
cd(p1);
addpath(genpath(p1));