function [ Px ] = F_LoadWindFutData( Product, SpotTicker, Exchange, SDate, EDate, WindAPI )
% 从WindAPI中读取期货的日数据
%   输入变量：期货大类代码，现货数据代码，交易所，开始时间，结束时间，WindAPI

disp(['Loading Meta ...']);
Px.Product=Product;
Px.LastUpdate = EDate-1;

Px.Contract = {};
Px.CtrYear = [];
Px.CtrMonth = [];

StartYear=year(SDate)-1;
EndYear=year(EDate)+1;
UpperMonth=month(EDate);%不超过1 year after Current Date,后续更新的时候此数值需要根据实际情况修改

for Year=StartYear:EndYear
    for Month=1:12
        if Year>=EndYear && Month>=UpperMonth
              break
        else
            YearStr=num2str(Year);
            TickerYear=YearStr(end-1:end);
            MonthStr=num2str(Month);
            if length(MonthStr)<2
                TickerMonth=strcat('0',MonthStr);
            else
                TickerMonth=MonthStr;
            end
            
            % Special Treat for Ticker Change in CZC            
            Contract = Product;
            if Year*100+Month < 201307 && strcmp(Exchange,'CZC')
                switch upper(Product)
                    case 'OI'
                        Contract = 'RO';
                    case 'RI'
                        Contract = 'ER';
                    case 'WH'
                        Contract = 'WS';
                end
            end
            %
            
            Px.Contract=[Px.Contract strcat(Contract,TickerYear,TickerMonth,'.',Exchange)];
            Px.CtrYear=[Px.CtrYear Year];
            Px.CtrMonth = [Px.CtrMonth Month];
        end
    end
end

%% Load Data From Wind
disp(['Loading Data ...']);

[Time,~,~,~,~,~]=WindAPI.tdays(SDate,EDate);
Px.Date=datenum(Time);


Px.LastTradeDate = nan(size(Px.Contract));
Px.SpotPrice = nan(size(Px.Date));

Px.PreClose = nan(numel(Px.Date),numel(Px.Contract));
Px.Open     = nan(numel(Px.Date),numel(Px.Contract));
Px.High     = nan(numel(Px.Date),numel(Px.Contract));
Px.Low      = nan(numel(Px.Date),numel(Px.Contract));
Px.Close    = nan(numel(Px.Date),numel(Px.Contract));
Px.Volume   = nan(numel(Px.Date),numel(Px.Contract));
Px.Value    = nan(numel(Px.Date),numel(Px.Contract));
Px.OpenInt  = nan(numel(Px.Date),numel(Px.Contract));
Px.OIChange = nan(numel(Px.Date),numel(Px.Contract));


% Future Contract Data
for i=1:length(Px.Contract)
    % Special Treat for CZCE
    Contract = Px.Contract{i};
    if strcmp(Exchange, 'CZC') && (Px.CtrYear(i) > year(today) || (Px.CtrYear(i) == year(today()) && Px.CtrMonth(i) >= month(today())))
        Contract(end-7) = [];
    end
    disp([Px.Contract{i} ' as ' Contract]);
    
    [Data,Code,Field,Time,ID]=...
        WindAPI.wsd(Contract,'pre_close,open,high,low,close,volume,amt,oi,oi_chg,lasttrade_date',SDate,EDate);%,'Fill=Previous');
    [FldFlag, FldPos] = ismember(upper({'pre_close','open','high','low','close','volume','amt','oi','oi_chg','lasttrade_date'}),upper(Field));
    
    if any(~FldFlag)
        error('Field Missing! ');
    end
    if ID ~= 0
        error('Retrieval Error!');
    end
        
    if all(cellfun(@(x) all(isnan(x)), Data(:,FldPos(end))))
        % No Data Available
        warning(['No Data for ' Px.Contract{i}]);
    else
        [DateFlag, DatePos] = ismember(Px.Date, Time);
        DatePos(DatePos == 0) = [];
        
        Px.PreClose(DateFlag, i)    = cell2mat(Data(DatePos, FldPos(1)));
        Px.Open(DateFlag, i)        = cell2mat(Data(DatePos, FldPos(2)));
        Px.High(DateFlag, i)        = cell2mat(Data(DatePos, FldPos(3)));
        Px.Low(DateFlag, i)         = cell2mat(Data(DatePos, FldPos(4)));
        Px.Close(DateFlag, i)       = cell2mat(Data(DatePos, FldPos(5)));
        Px.Volume(DateFlag, i)      = cell2mat(Data(DatePos, FldPos(6)));
        Px.Value(DateFlag, i)       = cell2mat(Data(DatePos, FldPos(7)));
        Px.OpenInt(DateFlag, i)     = cell2mat(Data(DatePos, FldPos(8)));
        Px.OIChange(DateFlag, i)    = cell2mat(Data(DatePos, FldPos(9)));
        
        Px.LastTradeDate(i) = datenum(Data(end, FldPos(10)));
        
        DateFilter = Px.Date > Px.LastTradeDate(i);
        Px.PreClose(DateFilter,i) = nan;
        Px.Open(DateFilter,i) = nan;
        Px.High(DateFilter,i) = nan;
        Px.Low(DateFilter,i) = nan;
        Px.Close(DateFilter,i) = nan;
        Px.Volume(DateFilter,i) = nan;
        Px.Value(DateFilter,i) = nan;
        Px.OpenInt(DateFilter,i) = nan;
        Px.OIChange(DateFilter,i) = nan;
    end
end

% Spot Price
if ~isempty(SpotTicker)
    [SpotPrice,~,~,SpotTime,~,~] = WindAPI.edb(SpotTicker,SDate,EDate);
    [DateFlag, DatePos]          = ismember(Px.Date, SpotTime);
    DatePos(DatePos == 0) = [];
    Px.SpotPrice(DateFlag)       = SpotPrice(DatePos);
end

end

