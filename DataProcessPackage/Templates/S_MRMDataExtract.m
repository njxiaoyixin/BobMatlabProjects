%������ȡ������ͭ�ķ��Ӽ�Tick����
clear all
% addpath F:\�����ļ�\�����о�\��Ƶ���ݴ���\ReadTickData\���������ݸ��¹���V20160111\������Ʒ��Ƶ���ݶ�д���߰�
s=WindPackage.ReadTick;
s.SetProperties('SDate',datenum('2010-1-1'),'EDate',datenum('2015-12-31'));
Product_List      = {'Y','P'};
Exchange_List     = {'DCE','DCE'};
ProductType_List  = {'FUT','FUT'};
%% ��ȡTick��ʹ��Wind����Դ��
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[pwd,'/YP����/',Product_List{i}]);
    %��ȡ1��������
    s.ReadProductTick_toCSV;
end
%% ��ȡ���ӣ�ʹ��Bloomberg����Դ��
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[pwd,'/MRM����/',Product_List{i}]);
    %��ȡ1��������
    s.ReadProductBar_toMAT(1);
end