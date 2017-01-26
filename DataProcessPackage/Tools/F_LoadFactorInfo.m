%%=========================================================================  
% �������ƣ�F_LoadFactorInfo
% ���������sFactorInfoFile,������sFactorInfo��XML������������FundaFactor�Լ�TechFactor������TechFactorΪ����Factor��FundaFactorΪ���Ե�Fundamental Factor  
% ���������[sFactorInfo,sFundaFactors,sTechFactors] ����һ��Ϊxml������ԭʼfactor
% info���ڶ���Ϊ���ظ���fundaFactor��info��������ΪtechFactor��info�����߶�Ϊstruct�� ������������ȡ����ʹ��
% ��Ҫ���ܣ����ļ��ж�ȡFactor����Ϣ�����������Ӧ��Struct
% �㷨���̣�1��  ��XML�ж�ȡFactor��ԭʼ��Ϣ
%          2��  ���ݶ�ȡ��sFactorInfo����������ظ���FundaFactor�Լ�TechFactor
% ע�����1��  sFactorInfo - Gold - FundaFactors - {ticker,name,controlability,BaseFactors}
%                                                                               BaseFactors - {factorName,funcName,ticker,field,freq,publishDay,remarks}
%                                  - TechFactors  
%                           - AllProducts -TechFactors - BaseFactors
%                                                      - AdvancedFactors
%          2��  
% �汾:    1.0
%          1.1 2017-1-9 ������Ƕ�׵�˳�򣬽�product�ᵽ���棬�����������ӿ�GeneralProduct
%               ����cProduct���
%%=========================================================================  % 
function [sFactorInfo,sFundaFactors,sTechFactors,CodeMap]=F_LoadFactorInfo(sFactorInfoFile)
% ���ڴ������ļ��ж�ȡ���ӵ���Ϣ����Ϊ���ݴ�����׼��

% �������: struc_products��ÿһ�����Ϊһ��Ʒ�ֵ����֣�ÿ��Ʒ����������Ӧ������factor(����funda�Լ�tech)�Լ�FactUpdateInfo
%          struc_fundaFactors,����Ʒ�ֲ��ظ���fundamental factor list
%          struc_techFactors,����Ʒ�ֵļ�����������

% ��XML������������Ϣ
if nargin<1
%     sFactorInfoFile = 'F:\�����ļ�\�����о�\��Ʒ�ڻ�\��Ʒ�ڻ�������\Codes\factorlibrary.xml';
    sFactorInfoFile = 'F:\�����ļ�\�����о�\��Ƶ���ݴ���\ReadTickData\���������ݸ��¹���V20160828\Config\EDBCodeMap.xml';
end
sFactorInfo = xml_read(sFactorInfoFile);
% sFactorInfo ����FundaFactors�Լ�TechFactors
% ����FundaFactors�������е�Ʒ�ֵĻ���������,TechFactors�������е�Ʒ�ֹ���ļ���������
% ����sFactorInfo���ҵ����ж�һ�޶���FundaFactor,�Լ�TechFactor

% Ŀǰ���е�TechFactors���ǹ����
sTechFactors  = sFactorInfo.GeneralFactors.TechFactors;
sTechFactors.BaseFactor  = sTechFactors.BaseFactor([sTechFactors.BaseFactor.indicator]>0);

% ��ȡ������Ĺ���Factor
CodeMap = sFactorInfo.Product;
CodeMap = CodeMap([sFactorInfo.Indicator.indicator]>0);
thisBaseFactors     = [];
for iProduct=1:numel(CodeMap)
    if ~isfield(CodeMap(iProduct).FundaFactors,'BaseFactor') || isempty(CodeMap(iProduct).FundaFactors.BaseFactor)
        continue
    end
    CodeMap(iProduct).FundaFactors.BaseFactor = CodeMap(iProduct).FundaFactors.BaseFactor([CodeMap(iProduct).FundaFactors.BaseFactor.indicator]>0);
    thisBaseFactors = [thisBaseFactors;CodeMap(iProduct).FundaFactors.BaseFactor]; %#ok<AGROW>
end
% ����һ�޶���Factor ��ȡ����
tickers  = {thisBaseFactors.ticker};
[~,IA,~] = unique(tickers);
sFundaFactors.BaseFactor = thisBaseFactors(IA);



