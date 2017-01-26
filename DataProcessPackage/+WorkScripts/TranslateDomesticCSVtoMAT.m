%���Ѿ��е�csv�ļ�ȫ��ת��.mat��ʽ
function TranslateDomesticCSVtoMAT(SDate,EDate,varargin)
%����Ĭ�ϲ���
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���

addOptional(p,'SDate',today,@isnumeric);
addOptional(p,'EDate',today,@isnumeric);
addParameter(p,'TargetFolder','F:\�ڻ��ֱ�����mat',@ischar);
addParameter(p,'DataSource','F:\�ڻ��ֱ�����',@ischar);
valid_searchMode    = {'Ticker','Folder'};
addParameter(p,'SearchMode','Folder',@(x)any(validatestring(upper(x),upper(valid_searchMode))));
addParameter(p,'Overwrite',true,@(x)islogical(x)||isnumeric(x));
addParameter(p,'InputType','Tick',@(x)ischar(x));
addParameter(p,'OutputType','Tick',@(x)ischar(x));
parse(p,SDate,EDate,varargin{:})

ThisTargetFolder=p.Results.TargetFolder;
ThisDataSource  =p.Results.DataSource;
sm         = eval(['WindPackage.',p.Results.OutputType,'Data']);

sm.SetProperties('SDate',p.Results.SDate,'EDate',p.Results.EDate,'TargetFolder',ThisTargetFolder,'DataSource',ThisDataSource);
tic
disp(['Now Starting Translate csv to mat with date range from ',datestr(p.Results.SDate),' to ',datestr(p.Results.EDate)])
sm.ReadProduct_Divided(p.Results.InputType,p.Results.OutputType,'CSV','MAT','Interval',1,'SearchMode',p.Results.SearchMode,'Overwrite',p.Results.Overwrite);
toc
% 
% CodeMap=sm.GetFullCodeMap;
% 
% 
% for i = 1:numel(CodeMap.Product)
%     if isnan(CodeMap.Product{i})
%         continue
%     end
%     disp(CodeMap.Product{i})
%     ThisProduct     = CodeMap.Product{i};
%     ThisExchange    = CodeMap.Exchange{i};
%     ThisProductType = CodeMap.ProductType{i};
%     sm.SetProperties('Product',ThisProduct,'Exchange',ThisExchange,'ProductType',ThisProductType,'SDate',SDate,'EDate',EDate,'TargetFolder',ThisTargetFolder,'DataSource',ThisDataSource);
%     sm.UpdateTickerSet;
%     sm.ReadProduct_Divided('Tick','Tick','CSV','MAT',1,varargin{:});
% %     s.ReadProductTick_CSVtoMAT_Concat
% end
% toc
