@ECHO OFF
ECHO MATLAB�Զ����п�ʼ
ECHO **************************************************
ECHO ȡ��batch�ļ��ĵ�ַ(��һ��Ŀ¼)
REM set batch_folder="F:\�����ļ�\�����о�\BobQuantBox\DataProcess\"

REM ECHO batch_folder=%batch_folder%

cd D:\

ECHO **************************************************
ECHO ��ʼִ��Matlab��m�ļ�
REM set command="addpath('%batch_folder%'),cd('%batch_folder%'),S_DownLoadBBGBar;exit;"
REM ECHO command=%command%
REM matlab -nosplash -nodesktop -minimize -r %command%
matlab -nosplash -nodesktop -minimize -r "S_DownloadFTPData('DataProvider','Bloomberg','InputType','Bar','OutputType','Bar','InputFileType','csv','OutputFileType','mat');exit;"

ECHO **************************************************
ECHO MATLAB�Զ����н���
