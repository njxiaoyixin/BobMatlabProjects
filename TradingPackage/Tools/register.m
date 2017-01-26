addpath(genpath(pwd));
ctp_path=which('ctpcom.dll');
system(['Regsvr32.exe ',ctp_path]);