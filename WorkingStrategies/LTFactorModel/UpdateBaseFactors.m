function UpdateBaseFactors()
% ���ڸ������ӻ������ݣ��������������ݺͼ���������
% Load Config
addpath(genpath(pwd))
Config       = xml_read('Config.xml');
if ischar(Config.SDate) && any(regexpi(Config.SDate,'today'))
    SDate= eval(Config.SDate);
else
    SDate   = Config.SDate;
end
if ischar(Config.EDate) && any(regexpi(Config.EDate,'today'))
    EDate= eval(Config.EDate);
else
    EDate = Config.EDate;
end
DataDir      = Config.DataDir;

[sFactorInfo,sFundaFactors,sTechFactors,CodeMap]=F_LoadFactorInfo;
% ������������ճ����һ�𣬲����롢���ʱ��
% ��Ĭ�����еĻ��������ݸ���ʱ�䶼Ϊ�����ڵĿ�ʼ�������ڶ�����һ�ڵ�����
load GlobalTradeDay.mat
TradeDay.Daily = GlobalTradeDay.SH;
TradeDay.Daily = TradeDay.Daily(TradeDay.Daily>=SDate & TradeDay.Daily<=EDate);
% ת������Ƶ��
% �����ܽ�����
RD = WindPackage.DailyData;
[OpenTimeSlots,TimeSlots]=F_GenerateTimeSlots(RD,TradeDay.Daily,'byWeek',true);
TradeDay.LF = TimeSlots;
save(fullfile(DataDir,'Data\CodeMap.mat'),'CodeMap', 'sFundaFactors', 'sTechFactors','sFactorInfo','TradeDay')
%% ������������������һ��
% RawData�ļ��д��δ����ʱ��Ƶ�ʺ�δ��������ݣ�Data�ļ��д���Ѿ����봦��õ�����
DataSource   = 'F:\EDB����mat';
TargetFolder = fullfile(DataDir,'RawData\FundaFactors\BaseFactor');

RD = WindPackage.DailyData;
RD.SetProperties('TargetFolder',DataSource,'SDate',SDate,'EDate',EDate,...
    'Exchange','EDB','ProductType','EDB');
InputType      = 'Daily';
OutputType     = 'Daily';
InputFileType  = 'mat' ;
OutputFileType = 'mat';
fundaBaseFactorNames = {sFundaFactors.BaseFactor.factorName};
FileIndex = F_IndexAll(RD,DataSource);
%%
for iFundaFactor=1:numel(fundaBaseFactorNames)
    RD.SetProperties('Product',sFundaFactors.BaseFactor(iFundaFactor).ticker);
    OutFileIndex = RD.ReadProduct_Concat (InputType,OutputType,InputFileType,OutputFileType,...
        'ConcatTargetFolder',TargetFolder,'FileIndex',FileIndex);
    if isempty(OutFileIndex)|| ~isfield(OutFileIndex,'FullFilename')
        continue
    end
    RawData= RD.F_Read_MAT(OutFileIndex(1).FullFilename); 
    % ת������Ƶ��
    [thisOpenTimeSlots,thisTimeSlots]=F_GenerateTimeSlots(RD,RawData.Time,'byWeek',true);
    DataOut = F_FreqTrans(RD,RawData,0,thisOpenTimeSlots,thisTimeSlots);
    sFundaFactors.BaseFactor(iFundaFactor).originalData = RawData;
    sFundaFactors.BaseFactor(iFundaFactor).Data_LF      = DataOut;
end
%% �����������ݴ����ͬƵ�ʣ���Ƶ��ȡʱ��㣬��Ƶ���Ƶ���
for iFundaFactor=1:numel(fundaBaseFactorNames)
    thisData = struct('Time',TradeDay.LF,'Close',nan(size(TradeDay.LF)));
    for iTradeDay = 1:numel(TradeDay.LF)
        idx = find(sFundaFactors.BaseFactor(iFundaFactor).Data_LF.Time<TradeDay.LF(iTradeDay),1,'last');
        if ~isempty(idx)
            % ����������ָ�����ʱ���жϺ���
            % Ĭ����ȡǰһʱ������
            thisData.Close(iTradeDay)  = sFundaFactors.BaseFactor(iFundaFactor).Data_LF.Close(idx);
        end
    end    
    sFundaFactors.BaseFactor(iFundaFactor).Data = thisData;
end
save(fullfile(DataDir,'Data\sFundaFactors.mat'), 'sFundaFactors');
%% ��ѯ�ܱ���fundaFactors������assign��ÿ��Ʒ��
fundaBaseFactors = repmat(struct(),numel(CodeMap),1);
for iProduct=1:numel(CodeMap)
    thisProduct  = CodeMap(iProduct).product;
    factorNames  = {sFactorInfo.Product(iProduct).FundaFactors.BaseFactor.factorName};
    for iFactor = 1:numel(factorNames)
        BaseFactorList = {sFundaFactors.BaseFactor.factorName};
        idx = strcmpi(BaseFactorList,factorNames{iFactor});
        if any(idx)
            fundaBaseFactors(iProduct,1).Factor(:,iFactor)  = sFundaFactors.BaseFactor(idx).Data.Close;
            fundaBaseFactors(iProduct,1).FactorName{1,iFactor}= factorNames{iFactor};
        else
            disp([factorNames{iFactor},' of product ',thisProduct,' Data Missing!'])
        end
    end
end
save(fullfile(DataDir,'Data\fundaBaseFactors'),'fundaBaseFactors');
%% ������������������һ��
% RawData�ļ��д��δ����ʱ��Ƶ�ʺ�δ��������ݣ�Data�ļ��д���Ѿ����봦��õ�����
load(fullfile(DataDir,'Data','CodeMap'))
DataSource   = 'F:\�ڻ�������mat';
TargetFolder = fullfile(DataDir,'\RawData\TechFactors\BaseFactor');

RD = WindPackage.DailyData;
RD.SetProperties('TargetFolder',DataSource,'SDate',SDate,'EDate',EDate,'ProductType','FUT');
InputType      = 'Daily';
OutputType     = 'Daily';
InputFileType  = 'mat';
OutputFileType = 'mat';
FileIndex = F_IndexAll(RD,DataSource);
%% Retrieve Price Data
% Always daily bar, construct lower frequency data later
for iProduct=1:numel(CodeMap)
    RD.SetProperties('Product',CodeMap(iProduct).product,'Exchange',CodeMap(iProduct).exchange);
    RD.ReadProduct_Concat (InputType,OutputType,InputFileType,OutputFileType,...
        'ConcatTargetFolder',TargetFolder,'FileIndex',FileIndex);
end
% �ϳ�������Լ
DP=DataProcess;
DP.SetProperties('DataProvider','Wind','SDate',SDate,'EDate',EDate,'ProductType','FUT')
Px = struct();

disp('Construct Px...')
PxActive_Align = struct;
PxActive_LF    = struct;
for i=1:numel(CodeMap)
    disp(CodeMap(i).product)
    thisProduct = strtrim(CodeMap(i).product); %��ֹ�������пո����
    DP.SetProperties('Product',CodeMap(i).product,'Exchange',CodeMap(i).exchange,...
        'PxDataSource',TargetFolder);
%     [thisPx,thisPxActive] = DP.ConstructDailyPx('InputFileType','mat','Allowedfields',{sTechFactors.BaseFactor.factorName});
    [thisPx,thisPxActive] = DP.ConstructDailyPx('InputFileType','mat');
    Px.(thisProduct) = thisPx;
    PxActive.(thisProduct) = thisPxActive;
    
    if isempty(PxActive.(thisProduct))
        PxActive_Align.(thisProduct) = [];
        PxActive_LF.(thisProduct) = [];
        warning(['No Tech Factor Data for Product�� ',thisProduct])
        continue
    end
    % Fill Price Data(current,no lag)
    Fields = fieldnames(PxActive.(thisProduct));
    temp   = struct;
    temp.Time = TradeDay.Daily;
    for iField = 1:numel(Fields)
        if strcmpi(Fields{iField},'Time')
            continue
        end
        temp.(Fields{iField}) = nan(size(TradeDay.Daily));
        for iTradeDay = 1:numel(TradeDay.Daily)
            idx = find(floor(PxActive.(thisProduct).Time)==floor(TradeDay.Daily(iTradeDay)),1,'last');
            if ~isempty(idx)
                temp.(Fields{iField})(iTradeDay) = PxActive.(thisProduct).(RD.F_GetInternalField(Fields{iField}))(idx);
            end
        end
    end
    PxActive_Align.(thisProduct) = temp;
    
    % Construct Lower frequency data
    [thisOpenTimeSlots,thisTimeSlots]=F_GenerateTimeSlots(RD,PxActive.(thisProduct).Time,'byWeek',true);
    PxActive_LF.(thisProduct) = F_FreqTrans(RD,PxActive.(thisProduct),0,thisOpenTimeSlots,thisTimeSlots);    
end
save(fullfile(DataDir,'Data\PxActive'),'PxActive','PxActive_Align','PxActive_LF');
%% Fill Tech Base Factors
% Transform data from daily bar to lower frequency bar first
disp('Transforming Data Frequency and Fill Dates...')
techBaseFactors = struct();
for iProduct=1:numel(CodeMap)
    thisProduct  = CodeMap(iProduct).product;
    disp(thisProduct)
    if isempty(PxActive.(thisProduct))
        warning(['No Tech Factor Data for Product�� ',thisProduct])
        continue
    end
    % Retrieve Factor Data(Lag1)
    factorNames  = {sTechFactors.BaseFactor.factorName};
    factorCount  =1;
    for iFactor = 1:numel(factorNames)
        temp= nan(size(TradeDay.LF));
        if ~strcmpi(factorNames{iFactor},'Time')
            for iTradeDay = 1:numel(TradeDay.LF)
                idx = find(PxActive_LF.(thisProduct).Time<TradeDay.LF(iTradeDay),1,'last');
                % Ĭ����ȡǰһʱ������
                if ~isempty(idx)
                    temp(iTradeDay) = PxActive_LF.(thisProduct).(RD.F_GetInternalField(factorNames{iFactor}))(idx);
                end
            end
            techBaseFactors(iProduct,1).Factor(:,factorCount)   = temp;
            techBaseFactors(iProduct,1).FactorName{1,factorCount} = factorNames{iFactor};
            factorCount = factorCount+1;
        end
    end
end
save(fullfile(DataDir,'Data\techBaseFactors'),'techBaseFactors');
disp('Base Factor Data Processing Finished!')
