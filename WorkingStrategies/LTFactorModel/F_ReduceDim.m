function [coeff,score] = F_ReduceDim(trainData,varargin)
%����Ĭ�ϲ���
addpath(genpath(pwd))
Config       = xml_read('Config.xml');

p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���
% addParameter(p,'alpha',70,@(x)isnumerical(x));
parse(p,varargin{:});

% ����PCA���н�ά�������ά�������
alpha = Config.PCA.alpha;
[coeff,score,latent,tsquare,explained] = pca(trainData,'economy',true);
idx = find(cumsum(explained)>=alpha,1,'first');
coeff = coeff(:,1:idx);
score = score(:,1:idx);

% ����stepwise regression ���н�ά

% ����Lasso���н�ά
% [B,S] = lasso(N_inSampleData,FactorReturn(inSampleIdx,iProduct),'CV',10,'PredictorNames',predictorNames);
% [B,S] = lasso(N_inSampleData,FactorReturn(inSampleIdx,iProduct));

end