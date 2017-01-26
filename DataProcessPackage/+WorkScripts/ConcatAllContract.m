% function ConcatAllContract()

TargetFolder   = 'F:\Cache\Data\1Min\Bar';
ConcatTargetFolder = 'F:\Cache\Data\1Min\ConinuousBar';
SDate        = datenum('2003-1-1');
EDate        = datenum('2016-12-30');
s = WindPackage.TickData;
s.SetProperties('SDate',SDate,'EDate',EDate,'TargetFolder',TargetFolder);
% 获取所有的文件列表----------------
% FileIndex.FullFilenames = [];
% FileIndex.Dates     = [];
% FileIndex.Filenames = []; 
% Dates = s.F_GenerateDates;
% for date=Dates
%     disp(['Indexing ',datestr(date),' ...'])
%     [~,~,DateDir] = s.F_FolderExist(date,'SQ',s.TargetFolder);
%     [ thisResFiles, ~,thisFilenames] = DeepTravel( DateDir,[], 0,[]) ;
%     FileIndex.FullFilenames   = [FileIndex.FullFilenames;thisResFiles];
%     FileIndex.Filenames       = [FileIndex.Filenames;thisFilenames];
%     FileIndex.Dates           = [FileIndex.Dates;repmat(date,numel(thisResFiles),1)];
% end
% save config\WindDataIndex FileIndex
%------------------------------

load config\WindDataIndex
load WindCodeMap
for i=1:numel(CodeMap.Product)
    s.SetProperties('Product',CodeMap.Product{i},'Exchange',CodeMap.Exchange{i},...
        'ProductType',CodeMap.ProductType{i});
    s.ReadProduct_Concat('Bar','Bar','mat','mat','ConcatTargetFolder',ConcatTargetFolder,'FileIndex',FileIndex,'Overwrite',false);
end