@ECHO OFF
ECHO MATLAB自动运行开始
ECHO **************************************************
REM ECHO 取得batch文件的地址(上一层目录)
REM set batch_folder="D:\Bloomberg分钟数据\Codes"

REM ECHO batch_folder=%batch_folder%

D:\
ECHO **************************************************
ECHO 开始执行Matlab的m文件
REM set command="addpath('%batch_folder%'),cd('%batch_folder%'),S_ForeignBarDailyUpdate;exit;"
REM ECHO command=%command%
REM matlab -nosplash -nodesktop -minimize -r %command%
matlab -nosplash -nodesktop -minimize -r "S_UpdateLocalData('DataProvider','Bloomberg','InputType','Bar','OutputType','Bar','InputFileType','csv','OutputFileType','csv','TransformData',false,'ByDay',true,'Overwrite',false);exit"
ECHO **************************************************
ECHO MATLAB自动运行结束
