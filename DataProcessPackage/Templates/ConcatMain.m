%Data Set 1 
clear
clc
Product_List      = {'SIE','AG'};
Exchange_List     = {'CM','SQ'};
ProductType_List  = {'FUT','FUT'};
DataProvider_List = {'CQG','Wind'};
TimeZone_List     = {'EST','CN'};
TargetTimeZone_List = {'EST','CN'};
SDate  = datenum('2013-9-1');
EDate  = datenum('2015-9-31');

%%
%Data Set 2
Product_List        = {'XU','FFB','SSE50','XIN9I'};
Exchange_List       = {'SG','SF','SH','FT'};
ProductType_List    = {'IndexFut','IndexFut','Index','Index'};
DataProvider_List   = {'Bloomberg','Bloomberg','Bloomberg','Bloomberg'};
TimeZone_List       = {'CN','CN','CN','CN'};
TargetTimeZone_List = {'CN','CN','CN','CN'};
SDate               = datenum('2015-1-1');
EDate               = today()-1;
%% 把Tick滚成分钟
for i=1:numel(Product_List)
    disp(Product_List{i})
    s=eval([DataProvider_List{i},'Package.ReadTick']);
%     DataSource   = ['F:/',DataProvider_List{i},'Tick数据'];
    TargetFolder = ['F:/',DataProvider_List{i},'分钟数据'];
    s.SetProperties('SDate',SDate,'EDate',EDate)
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',TargetFolder);
    %提取1分钟数据
    if strcmpi(DataProvider_List{i},'CQG')
        InputFileType = 'ts';
    elseif strcmpi(DataProvider_List{i},'Bloomberg')
        continue   %Bloomberg已经是分钟数据
    else
        InputFileType = 'mat';
    end
    s.ReadProduct_Divided('Tick','Bar',InputFileType,'mat',1)
%     s.ReadProduct_Concat('Tick','Bar','mat','mat')
end
%% 把分钟滚成日数据
%该方法在国外的数据上会有漏（因为国外是24小时交易，取某日的文件可能会漏掉存放在前日或者后日文件中的数据
%改进方法：先将分钟数据的同一合约连成一个文件，再将其滚成日数据

for i=1:numel(Product_List)
    disp(Product_List{i})
    s=eval([DataProvider_List{i},'Package.ReadTick']);
    DataSource   = ['F:/',DataProvider_List{i},'分钟数据'];
    TargetFolder = ['F:/',DataProvider_List{i},'日数据'];
    s.SetProperties('SDate',SDate,'EDate',EDate,'DataSource',DataSource,'TargetFolder',TargetFolder);
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TimeZone',TimeZone_List{i},'TargetTimeZone',TargetTimeZone_List{i});
    %提取1分钟数据
    if strcmpi(DataProvider_List{i},'Bloomberg')
        s.ReadProduct_Divided('Bar','Day','CSV','mat',1)  ;
    else
        s.ReadProduct_Divided('Bar','Day','mat','mat',1);
    end
    s.ReadProduct_Concat('Bar','Bar','mat','mat');
end
%% 将主力合约的日和分钟数据连接起来
m=DataProcessPackage.DataProcess;
Px = struct();
HF = struct();
for i=1:numel(Product_List)
    disp(Product_List{i})
    ThisProduct = strtrim(Product_List{i}); %防止名字中有空格出现
    m.SetProperties('DataProvider',DataProvider_List{i})
    m.SetProperties('SDate',SDate,'EDate',EDate)
    m.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i});
    if any(strcmpi(Exchange_List{i},{'SF','SG'}))
        RollMode = 'Index';
    else
        RollMode = 'Comdty';
    end
    ThisPx = m.ConstructDailyPx('mat',[],RollMode);
    Px.(ThisProduct) = ThisPx;
    if strcmpi(DataProvider_List{i},'Bloomberg')
        InputFileType = 'csv';
    else
        InputFileType = 'mat';
    end
    ThisHF = m.ConstructMainHF(InputFileType,Px.(ThisProduct));
    HF.(ThisProduct) = ThisHF;
end
disp('Done')

%% 计算对价
[Time,IA,IB] = intersect(HF.XU.Time,HF.FFB.Time);
Domestic = HF.XU.Close(IA);
Foreign  = HF.FFB.Close(IB);
Parity   = Domestic ./ Foreign;
subplot(2,1,1);plot(Parity);legend('Parity');subplot(2,1,2);plotyy(1:numel(Time),Domestic,1:numel(Time),Foreign); legend('A50','IH')
%% 数据清洗
HF2 = struct();
for i=1:numel(Product_List)
Fields = fieldnames(HF.(Product_List{i}));
% 0.去除Nan数据
idx0     = ~isnan(HF.(Product_List{i}).Close);
B0 = Tools.FilterStruct(HF.(Product_List{i}),idx0,'ChangeCtrTime');

% 1.去除异常跳点
[~,idx1_temp,~]  = Tools.deleteoutliers(B0.Close,0.05,1);
idx1 = setdiff(1:numel(idx0),idx1_temp);
B1 = Tools.FilterStruct(B0,idx1,'ChangeCtrTime');

% 2.限制时间起点
idx2 = B1.Time > datenum('2002-1-1');
B2 = Tools.FilterStruct(B1,idx2,'ChangeCtrTime');

HF2.(Product_List{i}) = B2;
end






