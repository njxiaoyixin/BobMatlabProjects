@ECHO OFF
ECHO "MATLAB自动运行开始"
ECHO "**************************************************"
REM ECHO "取得batch文件的地址(上一层目录)"
REM set batch_folder="F:\工作文件\策略研究\高频数据处理\ReadTickData\国内外数据更新工具V20160504\"

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
ECHO 开始执行Matlab的m文件
REM ECHO set command="S_UpdateLocalData('DataProvider','Wind','InputType','Tick','OutputType','Tick','InputFileType','csv','OutputFileType','mat','TransformData',true,'ByDay',true,'Overwrite',true);exit;"
REM ECHO command=%command%
REM matlab -nosplash -nodesktop -minimize -r %command%
matlab -nosplash -nodesktop -minimize -r "S_UpdateLocalData('DataProvider','Wind','InputType','Tick','OutputType','Tick','InputFileType','csv','OutputFileType','mat','TransformData',true,'ByDay',true,'Overwrite',true);exit;"

ECHO "**************************************************"
ECHO MATLAB自动运行结束
