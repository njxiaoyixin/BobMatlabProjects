% 将郑商所发生了ticker Change之前的代码与之后的统一
Dates = datenum('2003-1-1'):today;
SourceFolder = 'F:\期货分笔数据mat';
ExchangeList = {'ZZ'};
s = WindPackage.TickData;
for date = Dates
    disp(['Now Processing ',datestr(date),' ...'])
    for ei = 1:numel(ExchangeList)
        exchange = ExchangeList{ei};
        [ExistFlag1,SourceSubDir] = s.F_FolderExist(date,exchange,SourceFolder);
        if ExistFlag1
            list=dir(SourceSubDir);  % list是一个结构体数组（struct array）
            for fi = 1:numel(list)
                if any(regexpi(list(fi).name,'\.mat')) || any(regexpi(list(fi).name,'\.csv'))
                    if any(regexpi(list(fi).name,'ZZTC....\....')) 
                        newname = regexprep(list(fi).name,'TC','zc','ignorecase');
                        disp(['Replacing ,',list(fi).name, ' with ',newname,' at ',SourceSubDir])
                        [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[SourceSubDir,'\',newname]);
                    end
                    if any(regexpi(list(fi).name,'ZZWS....\....')) 
                        newname = regexprep(list(fi).name,'WS','wh','ignorecase');
                        disp(['Replacing ,',list(fi).name, ' with ',newname,' at ',SourceSubDir])
                        [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[SourceSubDir,'\',newname]);
                    end
                    if any(regexpi(list(fi).name,'ZZWSX....\....')) 
                        newname = regexprep(list(fi).name,'WSX','wh','ignorecase');
                        disp(['Replacing ,',list(fi).name, ' with ',newname,' at ',SourceSubDir])
                        [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[SourceSubDir,'\',newname]);
                    end
                    if any(regexpi(list(fi).name,'ZZWSY....\....')) 
                        newname = regexprep(list(fi).name,'WSY','wh','ignorecase');
                        disp(['Replacing ,',list(fi).name, ' with ',newname,' at ',SourceSubDir])
                        [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[SourceSubDir,'\',newname]);
                    end
                    if any(regexpi(list(fi).name,'ZZSRX....\....')) 
                        newname = regexprep(list(fi).name,'SRX','SR','ignorecase');
                        disp(['Replacing ,',list(fi).name, ' with ',newname,' at ',SourceSubDir])
                        [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[SourceSubDir,'\',newname]);
                    end
                    if any(regexpi(list(fi).name,'ZZSRY....\....')) 
                        newname = regexprep(list(fi).name,'SRY','SR','ignorecase');
                        disp(['Replacing ,',list(fi).name, ' with ',newname,' at ',SourceSubDir])
                        [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[SourceSubDir,'\',newname]);
                    end
                    if any(regexpi(list(fi).name,'ZZER....\....')) 
                        newname = regexprep(list(fi).name,'ER','ri','ignorecase');
                        disp(['Replacing ,',list(fi).name, ' with ',newname,' at ',SourceSubDir])
                        [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[SourceSubDir,'\',newname]);
                    end
                    if any(regexpi(list(fi).name,'ZZRO....\....')) 
                        newname = regexprep(list(fi).name,'RO','oi','ignorecase');
                        disp(['Replacing ,',list(fi).name, ' with ',newname,' at ',SourceSubDir])
                        [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[SourceSubDir,'\',newname]);
                    end
                    if any(regexpi(list(fi).name,'ZZME....\....'))
                        newname = regexprep(list(fi).name,'ME','ma','ignorecase');
                        disp(['Replacing ,',list(fi).name, ' with ',newname,' at ',SourceSubDir])
                        [SUCCESS,MESSAGE,MESSAGEID] = movefile([SourceSubDir,'\',list(fi).name],[SourceSubDir,'\',newname]);
                    end
                end
            end
        end
    end
end

disp('Done')