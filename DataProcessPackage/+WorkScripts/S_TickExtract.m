%������ȡ������ͭ�ķ��Ӽ�Tick����
clear all
% addpath F:\�����ļ�\�����о�\��Ƶ���ݴ���\ReadTickData\���������ݸ��¹���V20160111\������Ʒ��Ƶ���ݶ�д���߰�
s=WindPackage.ReadTick;
s.SetProperties('SDate',datenum('2008-1-1'),'EDate',today-1);
Product_List      = {'Y','P','L','C','CS','M','RM','OI'};
Exchange_List     = {'DL','DL','DL','DL','DL','DL','ZZ','ZZ'};
ProductType_List  = {'FUT','FUT','FUT','FUT','FUT','FUT','FUT','FUT'};
TargetFolder      = 'F:\�����ļ�\�����о�\��Ƶ���ݴ���\ReadTickData\YH';
%% ��ȡTick��ʹ��Wind����Դ��
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %��ȡ1��������
    s.ReadProductTick_toCSV;
end
%% ��ȡ���ӣ�ʹ��Wind����Դ��
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}]);
    %��ȡ1��������
%     s.ReadProductBar_MATtoMAT_Divided(1);
%     s.ReadProductBar_MATtoMAT_Concat;
    s.ReadProductBar_CSVtoCSV_Concat
end