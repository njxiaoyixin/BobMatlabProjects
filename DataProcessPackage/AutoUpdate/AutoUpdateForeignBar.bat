@ECHO OFF
ECHO MATLAB�Զ����п�ʼ
ECHO **************************************************
REM ECHO ȡ��batch�ļ��ĵ�ַ(��һ��Ŀ¼)
REM set batch_folder="D:\Bloomberg��������\Codes"

REM ECHO batch_folder=%batch_folder%

D:\
ECHO **************************************************
ECHO ��ʼִ��Matlab��m�ļ�
REM set command="addpath('%batch_folder%'),cd('%batch_folder%'),S_ForeignBarDailyUpdate;exit;"
REM ECHO command=%command%
REM matlab -nosplash -nodesktop -minimize -r %command%
matlab -nosplash -nodesktop -minimize -r "S_UpdateLocalData('DataProvider','Bloomberg','InputType','Bar','OutputType','Bar','InputFileType','csv','OutputFileType','csv','TransformData',false,'ByDay',true,'Overwrite',false);exit"
ECHO **************************************************
ECHO MATLAB�Զ����н���
