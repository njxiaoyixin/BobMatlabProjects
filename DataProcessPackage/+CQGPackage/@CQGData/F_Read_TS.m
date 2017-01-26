function [Data,Status] = F_Read_TS(~,FileName)
%读取出的时间是保留原格式的（如果是字符则保留为字符）
fid = fopen(FileName,'rt');
if fid == -1
    Data   = [];
    Status = -1;
    return
end
fmtstr = '%s%s%f%s%f%s%s%s%f';
Raw=textscan(fid,fmtstr,'delimiter',',');
%             disp(isstruct(Raw))
if numel(Raw)>0
    Data.Symbol    = Raw{1};
    Data.Date      = datenum(Raw{2},'yyyymmdd');
    Data.SessionID = Raw{3};
    Data.Time      = mod(datenum(Raw{4},'HHMM'),1)+Data.Date;
    Data.Price     = Raw{5};
    Data.Type      = cell2mat(Raw{6}); %Transaction Indicator(A - ask, B - bid, T - trade, S - settlement)
    %                 Data.Condition = Raw{7}; %Market Condition (N-Normal,F-Fast Market)
    %                 Data.CorrFlag  = Raw{8}; %Correction Flag (N - normal, I - insert, F - filter delete, E - exchange delete)
    Data.Volume    = Raw{9};
else
    Data=[];
end
fclose(fid);
end