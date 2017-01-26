function Output=DownloadData(~,Ticker,Ticker_Backup,Exchange,SDate,EDate,API,varargin)
%设置默认参数
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数
valid_fields        = {'last','volume','oi','ask1','asize1','bid1','bsize1'};
addParameter(p,'Fields',{'last','volume','oi','ask1','asize1','bid1','bsize1'},@(x)any(validatestring(upper(x),upper(valid_fields))));
parse(p,varargin{:});
fields = p.Results.Fields{1};
for i=2:numel(p.Results.Fields)
    fields = [fields,',',p.Results.Fields{i}];
end

%Ticker不含交易所
switch upper(Exchange)
    case 'ZZ'
        TickerMonth = datenum(Ticker(end-3:end),'yymm');
        thisProduct = Ticker(1:end-4);
        Year  = year(TickerMonth);
        Month = month(TickerMonth);
        thisTicker = Ticker;
        if Year*100+Month < 201307
            switch upper(thisProduct)
                case 'OI'
                    thisTicker = regexprep(Ticker,thisProduct,'RO','ignorecase');
                case 'RI'
                    thisTicker = regexprep(Ticker,thisProduct,'ER','ignorecase');
                case 'WH'
                    thisTicker = regexprep(Ticker,thisProduct,'WS','ignorecase');
                otherwise
            end
        end
        if Year*100+Month < 201605
            switch upper(thisProduct)
                case 'ZC'
                    thisTicker = regexprep(Ticker,thisProduct,'TC','ignorecase');
                otherwise
            end
        end
        if Year*100+Month < 201506
            switch upper(thisProduct)
                case 'MA'
                    thisTicker = regexprep(Ticker,thisProduct,'ME','ignorecase');
                otherwise
            end
        end
        if (Year > year(today) || (Year == year(today()) && Month >= month(today())))
            FullTicker=[upper(thisTicker(1:end-4)),upper(thisTicker(end-2:end)),'.CZC'];
        else
            FullTicker=[upper(Ticker),'.CZC'];
        end
    case 'SQ'
        FullTicker=[upper(Ticker),'.SHF'];
    case 'DL'
        FullTicker=[upper(Ticker),'.DCE'];
    case 'SF'
        FullTicker=[upper(Ticker),'.CFE'];
    case {'SZ','SH','OF'}
        FullTicker=[Ticker,'.',Exchange];
    otherwise
        error(['Exchange ',Exchange,' Not Valid!'])
end

[Data,Code,Fields,Time,ID]=API.wst(FullTicker,fields,SDate,EDate);
[FldFlag, FldPos] = ismember(upper({fields}),upper(Fields));
%             if any(~FldFlag)
%                 error('Field Missing! ');
%             end
%             if ID ~= 0
%                 error('Retrieval error!');
%             end
if iscell(Data)
    % No Data Available
    %                 disp(['No Data for ' FullTicker]);
    Output=[];
    return
end
Output.Time     = cell(size(Time));
for i=1:numel(Time)
    Output.Time{i}=datestr(Time(i),'yyyy-mm-dd HH:MM:SS');
end
Output.Price    = Data(:,1);
Output.Volume   = Data(:,2);
%这里的Volume是当天的总和，需要进行一下差分
if numel(Output.Volume)>1
    Output.Volume(2:end)=Data(2:end,2)-Data(1:end-1,2);
end
Output.Open_Int = Data(:,3);
Output.SP1      = Data(:,4);
Output.SV1      = Data(:,5);
Output.BP1      = Data(:,6);
Output.BV1      = Data(:,7);
Output.IsBuy    = zeros(size(Time));
Output.IsBuy(Output.SP1<=Output.Price) = 1;
end