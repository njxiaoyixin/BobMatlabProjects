@ECHO OFF
ECHO MATLAB自动运行开始
ECHO **************************************************
ECHO 取得batch文件的地址(上一层目录)
REM set batch_folder="F:\工作文件\策略研究\BobQuantBox\DataProcess\"

REM ECHO batch_folder=%batch_folder%

cd D:\

ECHO **************************************************
ECHO 开始执行Matlab的m文件
REM set command="addpath('%batch_folder%'),cd('%batch_folder%'),S_DownLoadBBGBar;exit;"
REM ECHO command=%command%
REM matlab -nosplash -nodesktop -minimize -r %command%
matlab -nosplash -nodesktop -minimize -r "S_DownloadFTPData('DataProvider','Bloomberg','InputType','Bar','OutputType','Bar','InputFileType','csv','OutputFileType','mat');exit;"

ECHO **************************************************
ECHO MATLAB自动运行结束
