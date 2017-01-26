function funOnMarketData(obj,varargin)
w_wsq_reqid      = varargin{1};
w_wsq_isfinished = varargin{2};
w_wsq_errorid    = varargin{3};
w_wsq_data       = varargin{4};
w_wsq_codes      = varargin{5};
w_wsq_fields     = varargin{6};
w_wsq_times      = varargin{7};
% w_wsq_selfdata   = varargin{8};

AssignMarketData(obj,w_wsq_data,w_wsq_codes,w_wsq_fields)
% obj.MarketData(idx,1).updateTime         = w_wsq_times;%行情更新时间18

end
