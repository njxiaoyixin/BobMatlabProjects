%������ȡ������ͭ�ķ��Ӽ�Tick����
clear all
dbstop if error
% addpath F:\�����ļ�\�����о�\��Ƶ���ݴ���\ReadTickData\���������ݸ��¹���V20160111\������Ʒ��Ƶ���ݶ�д���߰�
Product_List      = {'SI','AG'};
Exchange_List     = {'CM','SQ'};
ProductType_List  = {'FUT','FUT','FUT'};
% TargetFolder      = 'F:\Wind��������';
TargetFolder      = 'F:\Test';
%% ��ȡTick��ʹ��Wind����Դ��
s=WindPackage.TickData;
s.SetProperties('SDate',datenum('2015-1-1'),'EDate',datenum('2015-12-31'),'DataSource','F:\�ڻ��ֱ�����mat');
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',TargetFolder);
    %��ȡ1��������
%     s.ReadProduct_Tick2Tick_CSV2CSV_Divided;
    s.ReadProduct_Divided('Tick','Tick','mat','mat',1)
%     s.ReadProduct_Concat('Tick','Bar','mat','mat')
end
%% ��ȡ���ӣ�ʹ��Wind����Դ��
s=WindPackage.TickData;
s.SetProperties('SDate',datenum('2016-1-1'),'EDate',today-1,'DataSource','F:\�ڻ��ֱ�����mat');
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %��ȡ1��������
    s.ReadProduct_Divided('Tick','Bar','mat','mat',1);
    s.ReadProduct_Concat('Tick','Bar','mat','mat');
end

%% ��ȡ���ӣ�ʹ��Bloomberg��������Դ��
s=BloombergPackage.BarData;
s.SetProperties('SDate',datenum('2016-7-1'),'EDate',today-1,'DataSource','F:/Bloomberg��������');
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %��ȡ1��������
    s.ReadProduct_Tick2Bar_CSV2MAT_Divided(1);
    s.ReadProduct_Tick2Bar_CSV2MAT_Concat
%     s.ReadProduct_Tick2Bar_MAT2MAT_Concat;
end

%% ��ȡ�����ݣ�ʹ��Bloomberg��������Դ��
s=BloombergPackage.ReadDaily;
s.SetProperties('SDate',datenum('2016-7-1'),'EDate',today-1,'DataSource','F:\Bloomberg��������');
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %��ȡ1��������
    s.ReadProduct_Divided('Bar','Day','csv','mat',1);
    s.ReadProduct_Concat('Day','Day','mat','mat');
%     s.ReadProduct_Tick2Bar_MAT2MAT_Concat;
end
%% ��ȡ�����ݣ�������ָ����ʱ�����䣨ʹ��Bloomberg��������Դ��
s=BloombergPackage.ReadDaily;
s.SetProperties('SDate',datenum('2015-7-1'),'EDate',today-1);
s.SetProperties('OpenTime',mod(datenum('16:00:01'),1),'SettleTime',mod(datenum('9:29:55'),1),'TimeZone','EST')
% s.SetProperties('OpenTime',mod(datenum('15:00:01'),1),'SettleTime',mod(datenum('15:00:00'),1)) %Ĭ�ϴ�½ʱ��
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %��ȡ1��������
    s.ReadProduct_Tick2Bar_CSV2MAT_Divided(1);
    s.ReadProduct_Tick2Bar_CSV2MAT_Concat
%     s.ReadProduct_Tick2Bar_MAT2MAT_Concat;
end


%% ��ȡ�����ݣ�ʹ��Wind����Դ��
s=WindPackage.ReadDaily;
s.SetProperties('SDate',datenum('2015-7-1'),'EDate',today-1);
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i},'Daily']);
    %��ȡ1��������
    s.ReadProduct_Tick2Bar_MAT2MAT_Divided(1);
    s.ReadProduct_Tick2Bar_MAT2MAT_Concat
%     s.ReadProduct_Tick2Bar_MAT2MAT_Concat;
end
%% ��ȡ�����ݣ�������ָ����ʱ�����䣨ʹ��Wind����Դ��
s=WindPackage.ReadDaily;
s.SetProperties('SDate',datenum('2015-1-1'),'EDate',today-1,'DataSource','F:\�ڻ��ֱ�����mat');
s.SetProperties('OpenTime',mod(datenum('16:00:01'),1),'SettleTime',mod(datenum('9:29:55'),1),'TimeZone','CN')
% s.SetProperties('OpenTime',mod(datenum('15:00:01'),1),'SettleTime',mod(datenum('15:00:00'),1)) %Ĭ�ϴ�½ʱ��
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'ProductType',ProductType_List{i},'TargetFolder','F:\Wind������');
    %��ȡ������
    s.ReadProduct_Divided('Tick','Bar','mat','mat',1)
    s.ReadProduct_Concat('Tick','Bar','mat','mat')
end

%% ��ȡ���ӣ�ʹ��CQG����Դ��
Product_List      = {'ZSE','ZLE','ZME'};
Exchange_List     = {'CB','CB','CB'};
ProductType_List  = {'FUT','FUT','FUT'};
TargetFolder      = 'F:\CQG��������';

s=CQGPackage.ReadTick;
s.SetProperties('SDate',datenum('2011-4-1'),'EDate',datenum('2015-12-31'));
for i=3%:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',TargetFolder);
    %��ȡ1��������
    s.ReadProduct_Divided('TICK','Bar','TS','mat',1)
end

