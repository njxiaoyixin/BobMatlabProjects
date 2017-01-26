%���Ѿ��е�csv�ļ�ȫ��ת��.mat��ʽ
function TranslateBar2Bar(SDate,EDate,Interval,varargin)
%����Ĭ�ϲ���
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���

addOptional(p,'SDate',today,@isnumeric);
addOptional(p,'EDate',today,@isnumeric);
addOptional(p,'Interval',1,@isnumeric);
valid_searchMode    = {'Ticker','Folder'};
addParameter(p,'SearchMode','Folder',@(x)any(validatestring(upper(x),upper(valid_searchMode))));
addParameter(p,'Overwrite',true,@(x)islogical(x)||isnumerical(x));
parse(p,SDate,EDate,Interval,varargin{:})
Interval = p.Results.Interval;
SDate    = p.Results.SDate;
EDate    = p.Results.EDate;

ThisTargetFolder=['F:\Cache\Data\',num2str(Interval),'Min\Bar'];
ThisDataSource  ='F:\Cache\Data\1Min\Bar';
sm         = WindPackage.TickData;

sm.SetProperties('SDate',SDate,'EDate',EDate,'TargetFolder',ThisTargetFolder,'DataSource',ThisDataSource);
tic
disp(['Now Starting Translate tick to bar with date range from',datestr(SDate),' to ',datestr(EDate)])
sm.ReadProduct_Divided('Bar','Bar','mat','MAT',Interval,'SearchMode',p.Results.SearchMode,'Overwrite',p.Results.Overwrite);
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
