function RunOneUpdate(obj,API)
thisFileType = 'csv'; %��ʱ�����е�FileType���趨Ϊcsv
for i=1:numel(obj.TickerSet)
    Output=obj.DownloadData(obj.TickerSet{i},obj.TickerSet_Backup{i},obj.Exchange,obj.SDate,obj.EDate,API);
    if ~isempty(Output)
        [ExistFlag,Dir] = obj.F_FolderExist(floor(obj.EDate),obj.Exchange,obj.DataSource);
        if ~ExistFlag
            mkdir(Dir);
        end
        FileName = obj.F_SetFileName(obj.TickerSet{i},obj.EDate,obj.Exchange,thisFileType);
        %ReadTick.F_WriteMAT(FileName,Data)
        %д���ļ������Ѿ����ļ����ڣ��򸲸�
        thisStr = ['obj.F_Write_',upper(thisFileType),'(FileName,Output,1);'];
        eval(thisStr);
    end
end
end