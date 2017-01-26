%%=========================================================================  
% 函数名称：F_LoadFactorInfo
% 输入参数：sFactorInfoFile,储存有sFactorInfo的XML，里面必须包含FundaFactor以及TechFactor，其中TechFactor为共享Factor，FundaFactor为个性的Fundamental Factor  
% 输出参数：[sFactorInfo,sFundaFactors,sTechFactors] ，第一个为xml读出的原始factor
% info，第二个为不重复的fundaFactor的info，第三个为techFactor的info，三者都为struct， 后两者用于提取数据使用
% 主要功能：从文件中读取Factor的信息，并整理成相应的Struct
% 算法流程：1）  从XML中读取Factor的原始信息
%          2）  根据读取的sFactorInfo，整理出不重复的FundaFactor以及TechFactor
% 注意事项：1）  sFactorInfo - Gold - FundaFactors - {ticker,name,controlability,BaseFactors}
%                                                                               BaseFactors - {factorName,funcName,ticker,field,freq,publishDay,remarks}
%                                  - TechFactors  
%                           - AllProducts -TechFactors - BaseFactors
%                                                      - AdvancedFactors
%          2）  
% 版本:    1.0
%          1.1 2017-1-9 更改了嵌套的顺序，将product提到外面，新增共享因子库GeneralProduct
%               增加cProduct输出
%%=========================================================================  % 
function [sFactorInfo,sFundaFactors,sTechFactors,CodeMap]=F_LoadFactorInfo(sFactorInfoFile)
% 用于从配置文件中读取因子的信息，并为数据处理做准备

% 输出变量: struc_products，每一个结点为一个品种的名字，每个品种下面有相应的所有factor(包括funda以及tech)以及FactUpdateInfo
%          struc_fundaFactors,所有品种不重复的fundamental factor list
%          struc_techFactors,所有品种的技术因子名称

% 从XML中载入因子信息
if nargin<1
%     sFactorInfoFile = 'F:\工作文件\策略研究\商品期货\商品期货多因子\Codes\factorlibrary.xml';
    sFactorInfoFile = 'F:\工作文件\策略研究\高频数据处理\ReadTickData\国内外数据更新工具V20160828\Config\EDBCodeMap.xml';
end
sFactorInfo = xml_read(sFactorInfoFile);
% sFactorInfo 包含FundaFactors以及TechFactors
% 其中FundaFactors包含所有的品种的基本面因子,TechFactors包含所有的品种共享的技术面因子
% 遍历sFactorInfo，找到所有独一无二的FundaFactor,以及TechFactor

% 目前所有的TechFactors都是共享的
sTechFactors  = sFactorInfo.GeneralFactors.TechFactors;
sTechFactors.BaseFactor  = sTechFactors.BaseFactor([sTechFactors.BaseFactor.indicator]>0);

% 提取基本面的共性Factor
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
% 将独一无二的Factor 提取出来
tickers  = {thisBaseFactors.ticker};
[~,IA,~] = unique(tickers);
sFundaFactors.BaseFactor = thisBaseFactors(IA);



