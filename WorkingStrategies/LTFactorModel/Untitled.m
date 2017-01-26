% Save Black Industry CSV
load Data\PxActive
load Data\CodeMap
load Data\sFundaFactors
RD = WindPackage.DailyData;
thisDir     = fullfile('RawData\YH\FundamentalData');
if ~exist(thisDir,'dir')
    mkdir(thisDir)
end
for iFactor = 1:numel(sFundaFactors.BaseFactor) 
    thisData = sFundaFactors.BaseFactor(iFactor).originalData;
    thisFilename = fullfile(thisDir,[sFundaFactors.BaseFactor(iFactor).ticker,'.csv']);
    Status        = RD.F_Write_CSV(thisFilename,thisData,1);
end
%%
for iProduct=1:numel(CodeMap)
    thisProduct = CodeMap(iProduct).product;
    thisDir     = fullfile('RawData\YH\PriceData',thisProduct);
    if ~exist(thisDir,'dir')
        mkdir(thisDir)
    end
    % 写入价格数据
    if isempty(PxActive.(thisProduct))
        continue
    end
    thisData    = PxActive.(thisProduct);
    thisFilename = fullfile(thisDir,[thisProduct,'.csv']);
    Status        = RD.F_Write_CSV(thisFilename,thisData,1);
    
    % 复制基本面数据到相应文件夹
    factorSet   = sFactorInfo.Product(iProduct).FundaFactors.BaseFactor;
    CodeMapFilename = fullfile(thisDir,'Info.csv');
    fid = fopen(CodeMapFilename,'wt+');
    fprintf(fid,'%s,%s,%s\n','Ticker','FactorName','Remarks');
    for iFactor = 1:numel(factorSet)
        if exist(sourceFilename,'file')
            targetFilename = fullfile(thisDir,[factorSet(iFactor).ticker,'.csv']);
            sourceFilename = fullfile(fullfile('RawData\YH\FundamentalData'),[factorSet(iFactor).ticker,'.csv']);
            copyfile(sourceFilename,targetFilename);
            fprintf(fid,'%s,%s,%s\n',factorSet(iFactor).ticker,factorSet(iFactor).factorName,factorSet(iFactor).remarks);
        end
    end
    fclose(fid);
end
%%
load Data\CodeMap
load Data\fundaBaseFactors
load Data\techBaseFactors
RD = WindPackage.DailyData;
for iProduct=1:numel(CodeMap)
    thisProduct = CodeMap(iProduct).product;
    thisDir     = fullfile('RawData\YH\AlignedData',thisProduct);
     if ~exist(thisDir,'dir')
        mkdir(thisDir)
    end
    % 写入价格数据
    thisData = struct;
    thisData.Time = floor(TradeDay.LF)-1;
    if ~isempty(techBaseFactors(iProduct).Factor)
        for iFactor = 1:numel(techBaseFactors(iProduct).FactorName)
            thisData.(techBaseFactors(iProduct).FactorName{iFactor}) = techBaseFactors(iProduct).Factor(:,iFactor);
        end
    end
    thisFilename = fullfile(thisDir,'technical.csv');
    RD.F_Write_CSV(thisFilename,thisData,1);
    
    % 写入基本面数据
    thisData = struct;
    thisData.Time = floor(TradeDay.LF)-1;
 
    factorSet   = sFactorInfo.Product(iProduct).FundaFactors.BaseFactor;
    CodeMapFilename = fullfile(thisDir,'Info.csv');
    fid = fopen(CodeMapFilename,'wt+');
    fprintf(fid,'%s,%s,%s\n','Ticker','FactorName','Remarks');
    
    if ~isempty(fundaBaseFactors(iProduct).Factor)
        for iFactor = 1:numel(fundaBaseFactors(iProduct).FactorName)
            thisData.(factorSet(iFactor).ticker) = fundaBaseFactors(iProduct).Factor(:,iFactor);
            fprintf(fid,'%s,%s,%s\n',factorSet(iFactor).ticker,factorSet(iFactor).factorName,factorSet(iFactor).remarks);
        end
    end
    fclose(fid);
    thisFilename = fullfile(thisDir,'fundamental.csv');
    RD.F_Write_CSV(thisFilename,thisData,1,'AllowCustomFields',true);
end