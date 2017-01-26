function F_ExtractDomesticBarData(Product_List,Exchange_List,ProductType_List,SDate,EDate,TargetFolder,Interval)
%��ȡָ���ڻ���Ʒ�ķ�������
if nargin < 7
    Interval = 1;
end

if nargin < 6
    TargetFolder      = [pwd,'/','Data'];
end
if ~exist(TargetFolder,'dir')
    mkdir(TargetFolder)
end
    
if nargin < 5
    EDate = today;
end
if nargin < 4
    SDate = datenum('2010-1-1');
end

addpath F:\�����ļ�\�����о�\��Ƶ���ݴ���\ReadTickData\���������ݸ��¹���V20160114\
s=WindPackage.ReadTick;
s.SetProperties('SDate',SDate,'EDate',EDate);

%% ��ȡ���ӣ�ʹ��Wind����Դ��
for i=1:numel(Product_List)
    disp(Product_List{i})
    s.SetProperties('Product',Product_List{i},'Exchange',Exchange_List{i},'TargetFolder',[TargetFolder,'/',Product_List{i}],'ProductType',ProductType_List{i});
    %��ȡ1��������
%     s.ReadProductBar_MATtoMAT_Divided(Interval);
    s.ReadProductBar_MATtoMAT_Concat(Interval);
end

end