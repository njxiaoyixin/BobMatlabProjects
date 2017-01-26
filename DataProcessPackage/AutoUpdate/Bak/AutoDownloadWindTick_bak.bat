@ECHO OFF
ECHO MATLAB自动运行开始
ECHO **************************************************
ECHO 取得batch文件的地址(上一层目录)
set batch_folder="F:\工作文件\策略研究\BobQuantBox\DataProcess\"

ECHO batch_folder=%batch_folder%

ECHO **************************************************
ECHO 开始执行Matlab的m文件
set command="addpath('%batch_folder%'),cd('%batch_folder%'),S_DownloadWindTick;exit;"
ECHO command=%command%
matlab -nosplash -nodesktop -minimize -r %command%

ECHO **************************************************
ECHO MATLAB自动运行结束
