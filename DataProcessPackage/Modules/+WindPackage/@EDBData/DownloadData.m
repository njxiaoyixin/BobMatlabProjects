function Output=DownloadData(~,Ticker,Ticker_Backup,Exchange,SDate,EDate,API,varargin)
%Ticker不含交易所
if strcmpi(Exchange,'SQ')
    FullTicker=[upper(Ticker),'.SHF'];
elseif strcmpi(Exchange,'DL')
    FullTicker=[upper(Ticker),'.DCE'];
elseif strcmpi(Exchange,'ZZ')
    %注：郑州当前存续的Ticker为TC601，而不是TC1601
    FullTicker=[upper(Ticker(1:end-4)),upper(Ticker(end-2:end)),'.CZC'];
elseif strcmpi(Exchange,'SF')
    FullTicker=[upper(Ticker),'.CFE'];
elseif strcmpi(Exchange,'SH') || strcmpi(Exchange,'SZ')
    FullTicker=[Ticker,'.',Exchange];
elseif strcmpi(Exchange,'EDB')
    FullTicker=Ticker;
else
    error('Exchange Not Exist!')
end
[Data,Code,Fields,Time,ID]=API.edb(FullTicker,SDate,EDate,'Fill=Previous');
% [FldFlag, FldPos] = ismember(upper({'last,volume,oi,ask1,asize1,bid1,bsize1'}),upper(Fields));
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
    Output.Time{i}=datestr(Time(i),'yyyy-mm-dd');
end
Output.Close    = Data(:,1);
end