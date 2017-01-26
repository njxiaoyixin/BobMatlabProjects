echo off
rem 注释内容
rem Matlab AutoRun
rem by Yixin
rem 2016.1.14

rem -nojvm 禁用java虚拟机
rem -nosplash 启用闪频（splash windows）禁用



start  D:\"ProgramFiles"\MATLAB_R2012a\bin\matlab.exe -nosplash -r "run('F:\工作文件\策略研究\高频数据处理\ReadTickData\国内外数据更新工具V20160114\S_DomesticDailyUpdate.m')"
