function [ mResFiles, iTCount, filenames ] = DeepTravel( strPath, mFiles, iTotalCount,thisFilenames )
if nargin <4
    thisFilenames = [];
end
if nargin <3
    iTotalCount = 0;
end
if nargin <2
    mFiles = [];
end
iTmpCount = iTotalCount;
path=strPath;
Files = dir(path);
LengthFiles = length(Files);
if LengthFiles <= 2
    mResFiles = mFiles;
    iTCount = iTmpCount;
    filenames = thisFilenames;
    return;
end

for iCount=2:LengthFiles
    if Files(iCount).isdir==1
        if any(regexpi(Files(iCount).name,'\w+'))
            filePath = fullfile(strPath,  Files(iCount).name);
            [mFiles, iTmpCount,thisFilenames] = DeepTravel( filePath, mFiles, iTmpCount,thisFilenames);
        end
    else
        iTmpCount = iTmpCount + 1;
        filePath = fullfile(strPath,Files(iCount).name);
        mFiles{iTmpCount,1} = filePath;
        thisFilenames{iTmpCount,1} = Files(iCount).name;
    end
end
mResFiles = mFiles;
iTCount = iTmpCount;
filenames = thisFilenames;
end