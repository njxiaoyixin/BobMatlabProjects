@ECHO OFF
ECHO "MATLAB�Զ����п�ʼ"
ECHO **************************************************
ECHO "ȡ��batch�ļ��ĵ�ַ(��һ��Ŀ¼)"
set batch_folder="F:\�����ļ�\�����о�\��Ƶ���ݴ���\ReadTickData\���������ݸ��¹���V20160504\"

ECHO batch_folder=%batch_folder%

ECHO **************************************************
ECHO "��ʼִ��Matlab��m�ļ�"
set command="addpath('%batch_folder%'),cd('%batch_folder%'),S_DomesticTickDailyUpdate;exit;"
ECHO command=%command%
matlab -nosplash -nodesktop -minimize -r %command%

ECHO **************************************************
ECHO "MATLAB�Զ����н���"
