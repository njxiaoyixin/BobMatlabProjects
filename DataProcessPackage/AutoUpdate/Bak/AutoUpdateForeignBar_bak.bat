@ECHO OFF
ECHO MATLAB�Զ����п�ʼ
ECHO **************************************************
ECHO ȡ��batch�ļ��ĵ�ַ(��һ��Ŀ¼)
set batch_folder="D:\Bloomberg��������\Codes"

ECHO batch_folder=%batch_folder%

ECHO **************************************************
ECHO ��ʼִ��Matlab��m�ļ�
set command="addpath('%batch_folder%'),cd('%batch_folder%'),S_ForeignBarDailyUpdate;exit;"
ECHO command=%command%
matlab -nosplash -nodesktop -minimize -r %command%

ECHO **************************************************
ECHO MATLAB�Զ����н���