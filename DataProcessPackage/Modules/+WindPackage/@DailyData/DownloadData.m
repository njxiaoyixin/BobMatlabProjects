function Output=DownloadData(obj,Ticker,Ticker_Backup,Exchange,SDate,EDate,API,varargin)
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

[InternalFields,WindFields] = GenerateFields(obj);
valid_fields                = InternalFields;
addParameter(p,'Fields',InternalFields,@(x)any(ismember(upper(x),upper(valid_fields))));
parse(p,varargin{:});
cFields = p.Results.Fields;
cFields = arrayfun(@(x) WindFields{strcmpi(InternalFields,cFields{x})},1:numel(cFields),'UniformOutput',false);
fields =cFields{1};
for i=2:numel(cFields)
    fields = [fields,',',cFields{i}]; %#ok<AGROW>
end
InputFileds = p.Results.Fields;

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
            FullTicker=[upper(thisTicker),'.CZC'];
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

[Data,Code,Fields,Time,ID]=API.wsd(FullTicker,fields,SDate,EDate);
[FldFlag, FldPos] = ismember(upper({fields}),upper(Fields));
%             if any(~FldFlag)
%                 error('Field Missing! ');
%             end
%             if ID ~= 0
%                 error('Retrieval error!');
%             end
if iscell(Data)
    if ischar(Data{1}) && any(regexpi(Data{1},'CWSDService: quota exceeded.'))
        error('You have Exceeded the weekly downloading quota!')
    else
        % No Data Available
        Output=[];
        return
    end
end
Output.Time     = cell(size(Time));
for i=1:numel(Time)
    Output.Time{i}=datestr(Time(i),'yyyy-mm-dd');
end

for i=1:numel(InputFileds)
    Output.(InputFileds{i}) = Data(:,i);
end

% Filter NaNs
filter = isnan(Output.Close)|Output.Volume==0|isnan(Output.Volume);
fields = fieldnames(Output);
for i=1:numel(fields)
    cFields = fields{i};
    Output.(cFields)(filter)=[];
end
if isempty(Output.Close)
    Output = [];
end