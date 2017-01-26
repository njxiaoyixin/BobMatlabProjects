function Output=DownloadData(~,Ticker,Ticker_Backup,Exchange,SDate,EDate,BBGAPI,other)%Exchange�ڶ�ȡBBG���ݵ�ʱ��û�����ã�ȥ��
%����API��ȡBloomberg����ʷBar����

%�����ڼ��Ticker��Ҫ�����ȥ��(ֻ���FUT or INDEXFUT)
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
%BBG������Ϊcell���ݣ�����4�У��ֱ�ΪTime,Type,Price,Volume
if isempty(Data)
    %�����Ҫ��Tickerû�����ݣ�����ʹ��BackupTicker��ȡ���ݣ������Ȼû�����ݣ��򷵻�
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