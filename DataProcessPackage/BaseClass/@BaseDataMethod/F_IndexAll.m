function FileIndex = F_IndexAll(obj,Folder)
OriginFileIndex.FullFilenames = [];
OriginFileIndex.Dates     = [];
OriginFileIndex.Filenames = []; 
Dates = obj.F_GenerateDates;
for date=Dates
    disp(['Indexing ',datestr(date),' ...'])
    [~,~,DateDir] = obj.F_FolderExist(date,'SQ',Folder);
    [ thisResFiles, ~,thisFilenames] = DeepTravel( DateDir,[], 0,[]) ;
    OriginFileIndex.FullFilenames   = [OriginFileIndex.FullFilenames;thisResFiles];
    OriginFileIndex.Filenames       = [OriginFileIndex.Filenames;thisFilenames];
    OriginFileIndex.Dates           = [OriginFileIndex.Dates;repmat(date,numel(thisResFiles),1)];
end
% FileIndex为n个Struct，每个struct含有FullFilename,Filename,以及date三个变量
FileIndex = repmat(struct('FullFilename','','Filename','','Date',''),numel(OriginFileIndex.Dates),1);
for iDate=1:numel(OriginFileIndex.Dates)
    FileIndex(iDate).FullFilename = OriginFileIndex.FullFilenames{iDate};
    FileIndex(iDate).Filename     = OriginFileIndex.Filenames{iDate};
    FileIndex(iDate).Date         = OriginFileIndex.Dates(iDate);
end