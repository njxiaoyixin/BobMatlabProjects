classdef BaseDataMethod < handle
    methods  %�������ݴ���ĺ���
        %���ڶ�д���ݵĺ���
        Data3           = F_LoadBar(obj,Data,Interval,isIntraday,varargin)
        OutFileIndex    = ReadProduct_Concat (obj,InputType,OutputType,InputFileType, OutputFileType,varargin)
        ReadProduct_Divided (obj,InputType,OutputType, InputFileType, OutputFileType,varargin) 
        status          = FileTranslation(obj,ThisFile,OutFileName,InputType,OutputType,InputFileType,OutputFileType,Interval,varargin)
        TradeTimeSeries = F_GenerateTradeTimeSeries(obj,Dates,Exchange,TimeZone,NightSessionFlag)%δ��ɣ���������ָ����Ʒ����������ʱ�䣬�Խ������
        [TimeZone,OpenTime,SettleTime,OpenTimeOffset,Calendar] = F_LookupExchangeTime(obj,Date,Exchange,Product)  % ���뽻�����Ͳ�Ʒ�����ҵõ���Ӧ��Ʒ�Ľ���ʱ��
        [STime,ETime]   = F_GenerateTradeTime(obj,Time,OpenTime,SettleTime,OpenTimeOffset,Calendar) %����ĳһʱ��㣬�õ���ǰʱ��εĿ�����ʱ��
        OutputTime      = F_ChangeTimeZone(obj,Time,TimeZone,TargetTimeZone)
        function UpdateTickerSet(obj)
           [ obj.TickerSet , obj.ContractMonth, obj.TickerSet_Backup, obj.LastAllowedTradeDay] =...
               obj.F_GenerateTicker(obj.Product,obj.Exchange,obj.ProductType,obj.SDate,obj.EDate,obj.Country);
        end
        function Dates         = F_GenerateDates(obj)
            Dates = obj.SDate:obj.EDate;
        end
        [ writeType,readType,FieldTable ]= F_GetFieldType(obj,field,varargin)
        [Data,Status] = F_Read_CSV(~,FileName,Header)
        Data          = F_Read_MAT(~,FileName)
        Status        = F_Write_CSV(~,FileName,Data,ReadOption,varargin)
        Status        = F_Write_MAT(~,FileName,Data,varargin)
        [Data,Status] = F_Read_TS(~,FileName)
     
        %����ÿ�����صĺ���
        CodeMap=GetFullCodeMap(obj);
        CodeMap=GetCodeMap(obj,FileName,SheetName,OutName)
        APIConnect(obj);
        APIDisconnect(obj);
        RunOneUpdate(obj,API)
        RunBatchUpdate(obj,Product_List,Exchange_List,ProductType_List,ThisSDate,ThisEDate,varargin)
        RunFullUpdate(obj,varargin)
        RunCustomUpdate(obj,FileName,SheetName,OutName,varargin)
        FID=RunOneUpdatePlus(obj,BBGAPI,FID,varargin)
        FID=RunBatchUpdatePlus(obj,Product_List,Exchange_List,ProductType_List,Country_List,ThisSDate,ThisEDate,FID,varargin)
        FID=RunFullUpdatePlus(obj,FID,varargin)
        FID=RunCustomUpdatePlus(obj,FID,FileName,SheetName,OutName,varargin)
        Output=DownloadData(~,Ticker,Ticker_Backup,Exchange,SDate,EDate,API,varargin) % ��������
        other = GetOtherData(obj,Data)
        FileIndex = F_IndexAll(obj,Folder)
        DataOut = F_ConcatFiles(obj,FileIndex,InputFileType)
        [OpenTimeSlots,TimeSlots]=F_GenerateTimeSlots(obj,TimeSeries,varargin)
         thisField = F_GetInternalField(obj,field,varargin)
         DataOut = F_FreqTrans(obj,Data,isIntraday,OpenTimeSlots,TimeSlots)
    end
    
    methods(Abstract) %�������صĺ���
        [ TickerSet , ContractMonth, TickerSet_Backup, LastAllowedTradeDay] = F_GenerateTicker(obj,Product,Exchange,ProductType,SDate,EDate,Country,Product_Backup)
        FileName              = F_SetFileName(obj,Ticker,Date,Exchange,OutputFileType);
        Ind                   = F_TickFilter(~,Data);
        [ExistFlag,Dir]       = F_FolderExist(~,Date,Exchange,DataSource)
        [ExistFlag,Dir]       = F_TargetFolderExist(~,Date,Exchange,DataSource)
    end
end