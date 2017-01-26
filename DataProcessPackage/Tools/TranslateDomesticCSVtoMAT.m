%将已经有的csv文件全部转成.mat格式
function TranslateDomesticCSVtoMAT(SDate,EDate,varargin)
%设置默认参数
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

addOptional(p,'SDate',today,@isnumeric);
addOptional(p,'EDate',today,@isnumeric);
addParameter(p,'TargetFolder','F:\期货分笔数据mat',@ischar);
addParameter(p,'DataSource','F:\期货分笔数据',@ischar);
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
