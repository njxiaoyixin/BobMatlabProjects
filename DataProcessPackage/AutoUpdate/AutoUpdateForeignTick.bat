@ECHO OFF
ECHO MATLAB�Զ����п�ʼ
ECHO **************************************************
ECHO ȡ��batch�ļ��ĵ�ַ(��һ��Ŀ¼)
if %cd%==%cd:~,3% echo ��ǰĿ¼�Ѿ���%cd:~,1%�̵ĸ�Ŀ¼��&goto end
cd..
set batch_folder=%cd%

ECHO batch_folder=%batch_folder%

ECHO **************************************************
ECHO �����п�ʼʱ�����ں�ʱ����ΪLog�ļ����ļ���
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
ECHO ��ʼִ��Matlab��m�ļ�
set command="addpath('%batch_folder%'),cd('%batch_folder%'),S_ForeignDailyUpdate;exit;"
ECHO command=%command%
matlab -nosplash -nodesktop -minimize -r %command%

ECHO **************************************************
ECHO MATLAB�Զ����н���
