@ECHO OFF
ECHO MATLAB自动运行开始
ECHO **************************************************
ECHO 取得batch文件的地址(上一层目录)
if %cd%==%cd:~,3% echo 当前目录已经是%cd:~,1%盘的根目录！&goto end
cd..
set batch_folder=%cd%

ECHO batch_folder=%batch_folder%

ECHO **************************************************
ECHO 将运行开始时的日期和时间做为Log文件的文件名
set sDate2=%date:~-10%
set sDate=%sDate2:/=%
set time_tmp=%time: =0%
set hh=%time_tmp:~0,2%
set mm=%time_tmp:~3,2%
set ss=%time_tmp:~6,2%
set sss=%time_tmp:~9,2%
set datetime=%sDate%_%hh%%mm%%ss%
set cPre_log=%datetime%_MatlabLog.log
ECHO %cPre_log%

ECHO **************************************************
ECHO 开始执行Matlab的m文件
set command="addpath('%batch_folder%'),cd('%batch_folder%'),S_ForeignDailyUpdate;exit;"
ECHO command=%command%
matlab -nosplash -nodesktop -minimize -r %command%

ECHO **************************************************
ECHO MATLAB自动运行结束
