function Output=DownloadData(~,Ticker,Ticker_Backup,Exchange,SDate,EDate,BBGAPI,other)%Exchange在读取BBG数据的时候没有作用，去掉
%利用API读取Bloomberg的历史Bar数据

%存续期间的Ticker需要将年份去掉(只针对FUT or INDEXFUT)
FullTicker=Ticker;
FullTicker_Backup=Ticker_Backup;

%d = timeseries(c,s,{startdate,enddate},[],field,options,values)
%retrieves raw tick data d for a specific date range without an aggregation interval for a specific field with specified options options and corresponding values values.
try
    Data=timeseries(BBGAPI,FullTicker,{SDate,EDate},1,{'Trade'});
catch err
    if strcmpi(err.identifier,'MATLAB:Java:GenericException')
        %                     Output=[];
        %                     return
        Data=[];
    else
        error(err)
    end
end
%BBG读出来为cell数据，共有4列，分别为Time,Type,Price,Volume
if isempty(Data)
    %如果主要的Ticker没有数据，则尝试使用BackupTicker读取数据，如果仍然没有数据，则返回
    try
        Data=timeseries(BBGAPI,FullTicker_Backup,{SDate,EDate},1,{'Trade'});
    catch err
        if strcmpi(err.identifier,'MATLAB:Java:GenericException')
            Output=[];
            return
        else
            error(err)
        end
    end
    if isempty(Data)
        Output=[];
        return
    end
end
Output.Time     = cell(size(Data,1),1);
for i=1:numel(Output.Time)
    Output.Time{i}=datestr(Data(i,1),'yyyy-mm-dd HH:MM:SS');
end
Output.Open      = Data(:,2);
Output.High      = Data(:,3);
Output.Low       = Data(:,4);
Output.Close     = Data(:,5);
Output.Volume    = Data(:,6);
Output.NumTick   = Data(:,7);
Output.Value     = Data(:,8);
end