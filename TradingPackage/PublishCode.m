thisDir = pwd;
addpath(genpath(pwd))
targetDir = 'F:\�����ļ�\�����о�\BobQuantBox\TradeAPI';
sourceList = {'','APIs','BaseData','BaseHandle','Tools','TradeTool'};

for i=1:numel(sourceList)
    thisSourceDir = fullfile(thisDir,sourceList{i});
    thisTargetDir = fullfile(targetDir,sourceList{i});
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

% �����ļ�
CopySourceList = {'Config'};
for i=1:numel(CopySourceList)
    thisSourceDir = fullfile(thisDir,CopySourceList{i});
    thisTargetDir = fullfile(targetDir,CopySourceList{i});
    [SUCCESS,MESSAGE,MESSAGEID] = copyfile(thisSourceDir,thisTargetDir);
end