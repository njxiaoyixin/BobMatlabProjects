% ��������2012��֮ǰ��ʱ������еĽ����������ļ��Ƶ�ͳһ�ĸ�ʽ��
Dates = datenum('2003-1-1'):datenum('2012-12-31');
SourceFolder = 'F:\�ڻ��ֱ�����';
ExchangeList = {'ZZ','DL','SQ','SF','SH','SZ'};
s = WindPackage.TickData;
for date = Dates
    disp(['Now Processing ',datestr(date),' ...'])
    for ei = 1:numel(ExchangeList)
        exchange = ExchangeList{ei};
        [ExistFlag1,SourceSubDir] = s.F_FolderExist(date,exchange,SourceFolder);
        if ExistFlag1
            [ExistFlag2,TargetSubDir] = s.F_TargetFolderExist(date,exchange,SourceFolder);
            if ~ExistFlag2
                mkdir(TargetSubDir)
            end
            disp(['Moving from ',SourceSubDir,' to ',TargetSubDir]);
            
            list=dir(SourceSubDir);  % list��һ���ṹ�����飨struct array��
            for fi = 1:numel(list)
                if any(regexpi(list(fi).name,'\.mat')) || any(regexpi(list(fi).name,'\.csv'))
                    [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[TargetSubDir,'\']);
                end
            end
        end
    end
end