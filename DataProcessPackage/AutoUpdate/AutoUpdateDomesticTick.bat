@ECHO OFF
ECHO "MATLAB�Զ����п�ʼ"
ECHO "**************************************************"
REM ECHO "ȡ��batch�ļ��ĵ�ַ(��һ��Ŀ¼)"
REM set batch_folder="F:\�����ļ�\�����о�\��Ƶ���ݴ���\ReadTickData\���������ݸ��¹���V20160504\"

REM batch_folder=%batch_folder%
REM ECHO set DataProvider = "Wind"
REM ECHO set InputType = "Tick"
REM ECHO set OutputType = "Tick"
REM ECHO set InputFileType = "csv"
REM ECHO set OutputFileType = "mat"
REM ECHO set TransformData = "true"
REM ECHO set ByDay = "true"
REM Echo set Overwrite = "true"

cd D:\

ECHO "**************************************************"
ECHO ��ʼִ��Matlab��m�ļ�
REM ECHO set command="S_UpdateLocalData('DataProvider','Wind','InputType','Tick','OutputType','Tick','InputFileType','csv','OutputFileType','mat','TransformData',true,'ByDay',true,'Overwrite',true);exit;"
REM ECHO command=%command%
REM matlab -nosplash -nodesktop -minimize -r %command%
matlab -nosplash -nodesktop -minimize -r "S_UpdateLocalData('DataProvider','Wind','InputType','Tick','OutputType','Tick','InputFileType','csv','OutputFileType','mat','TransformData',true,'ByDay',true,'Overwrite',true);exit;"

ECHO "**************************************************"
ECHO MATLAB�Զ����н���
