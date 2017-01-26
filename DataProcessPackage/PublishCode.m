thisDir = pwd;
addpath(genpath(pwd))
	
targetDir = 'F:\工作文件\策略研究\BobQuantBox\DataProcess';

% 制作Pcode
PCodeSourceList = {'','+BloombergPackage','+WindPackage','+CQGPackage','+WorkScripts','BaseClass','Tools'};
for i=1:numel(PCodeSourceList)
    thisSourceDir = fullfile(thisDir,PCodeSourceList{i});
    thisTargetDir = fullfile(targetDir,PCodeSourceList{i});
    sourceFileList = dir(thisSourceDir);
    if ~exist(thisTargetDir,'dir')
        mkdir(thisTargetDir)        
    end
    cd(thisTargetDir)
    pcode(thisSourceDir)
    for j=1:numel(sourceFileList)
        if strcmp(sourceFileList(j).name(1),'@')
            pcode(fullfile(thisSourceDir,sourceFileList(j).name))
        end
    end
end
cd(thisDir)

% 复制文件
CopySourceList = {'Config','AutoUpdate','SampleScripts'};
for i=1:numel(CopySourceList)
    thisSourceDir = fullfile(thisDir,CopySourceList{i});
    thisTargetDir = fullfile(targetDir,CopySourceList{i});
    [SUCCESS,MESSAGE,MESSAGEID] = copyfile(thisSourceDir,thisTargetDir);
end


