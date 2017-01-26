function [coeff,score] = F_ReduceDim(trainData,varargin)
%设置默认参数
addpath(genpath(pwd))
Config       = xml_read('Config.xml');

p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数
% addParameter(p,'alpha',70,@(x)isnumerical(x));
parse(p,varargin{:});

% 利用PCA进行降维，输出降维后的因子
alpha = Config.PCA.alpha;
[coeff,score,latent,tsquare,explained] = pca(trainData,'economy',true);
idx = find(cumsum(explained)>=alpha,1,'first');
coeff = coeff(:,1:idx);
score = score(:,1:idx);

% 利用stepwise regression 进行降维

% 利用Lasso进行降维
% [B,S] = lasso(N_inSampleData,FactorReturn(inSampleIdx,iProduct),'CV',10,'PredictorNames',predictorNames);
% [B,S] = lasso(N_inSampleData,FactorReturn(inSampleIdx,iProduct));

end