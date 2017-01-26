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
%% ��Tick���ɷ���
for i=1:numel(Product_List)
    disp(Product_List{i})
    s=eval([DataProvider_List{i},'Package.ReadTick']);
%     DataSource   = ['F:/',DataProvider_List{i},'Tick����'];
    TargetFolder = ['F:/',DataProvider_List{i},'��������'];
    s.SetProperties('SDate',SDate,'EDate',EDate)
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',TargetFolder);
    %��ȡ1��������
    if strcmpi(DataProvider_List{i},'CQG')
        InputFileType = 'ts';
    elseif strcmpi(DataProvider_List{i},'Bloomberg')
        continue   %Bloomberg�Ѿ��Ƿ�������
    else
        InputFileType = 'mat';
    end
    s.ReadProduct_Divided('Tick','Bar',InputFileType,'mat',1)
%     s.ReadProduct_Concat('Tick','Bar','mat','mat')
end
%% �ѷ��ӹ���������
%�÷����ڹ���������ϻ���©����Ϊ������24Сʱ���ף�ȡĳ�յ��ļ����ܻ�©�������ǰ�ջ��ߺ����ļ��е�����
%�Ľ��������Ƚ��������ݵ�ͬһ��Լ����һ���ļ����ٽ������������

for i=1:numel(Product_List)
    disp(Product_List{i})
    s=eval([DataProvider_List{i},'Package.ReadTick']);
    DataSource   = ['F:/',DataProvider_List{i},'��������'];
    TargetFolder = ['F:/',DataProvider_List{i},'������'];
    s.SetProperties('SDate',SDate,'EDate',EDate,'DataSource',DataSource,'TargetFolder',TargetFolder);
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TimeZone',TimeZone_List{i},'TargetTimeZone',TargetTimeZone_List{i});
    %��ȡ1��������
    if strcmpi(DataProvider_List{i},'Bloomberg')
        s.ReadProduct_Divided('Bar','Day','CSV','mat',1)  ;
    else
        s.ReadProduct_Divided('Bar','Day','mat','mat',1);
    end
    s.ReadProduct_Concat('Bar','Bar','mat','mat');
end
%% ��������Լ���պͷ���������������
m=DataProcessPackage.DataProcess;
Px = struct();
HF = struct();
for i=1:numel(Product_List)
    disp(Product_List{i})
    ThisProduct = strtrim(Product_List{i}); %��ֹ�������пո����
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

%% ����Լ�
[Time,IA,IB] = intersect(HF.XU.Time,HF.FFB.Time);
Domestic = HF.XU.Close(IA);
Foreign  = HF.FFB.Close(IB);
Parity   = Domestic ./ Foreign;
subplot(2,1,1);plot(Parity);legend('Parity');subplot(2,1,2);plotyy(1:numel(Time),Domestic,1:numel(Time),Foreign); legend('A50','IH')
%% ������ϴ
HF2 = struct();
for i=1:numel(Product_List)
Fields = fieldnames(HF.(Product_List{i}));
% 0.ȥ��Nan����
idx0     = ~isnan(HF.(Product_List{i}).Close);
B0 = Tools.FilterStruct(HF.(Product_List{i}),idx0,'ChangeCtrTime');

% 1.ȥ���쳣����
[~,idx1_temp,~]  = Tools.deleteoutliers(B0.Close,0.05,1);
idx1 = setdiff(1:numel(idx0),idx1_temp);
B1 = Tools.FilterStruct(B0,idx1,'ChangeCtrTime');

% 2.����ʱ�����
idx2 = B1.Time > datenum('2002-1-1');
B2 = Tools.FilterStruct(B1,idx2,'ChangeCtrTime');

HF2.(Product_List{i}) = B2;
end






