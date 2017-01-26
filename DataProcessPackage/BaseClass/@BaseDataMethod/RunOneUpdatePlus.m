function FID=RunOneUpdatePlus(obj,API,FID,varargin)
%设置默认参数
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;   % 不允许输入不属于列表的参数

addParameter(p,'Overwrite',true,@(x)islogical(x)||isnumerical(x));
addParameter(p,'FileType','csv',@(x)ischar(x));
parse(p,varargin{:});
%%
thisFileType = p.Results.FileType; %暂时将所有的FileType都设定为csv
if nargin<3
    FID=fopen([pwd,'\数据更新日志\',datestr(today,'yyyymmdd'),'.txt'],'at+');
end
ticID=tic;
for i=1:numel(obj.TickerSet)
    try
        disp(obj.TickerSet{i})
        TitleStr = ['现在更新的代码：',obj.TickerSet{i}];
        fprintf(FID,'%s\n',TitleStr);
        [ExistFlag,Dir] = obj.F_FolderExist(floor(obj.EDate),obj.Exchange,obj.DataSource);
        if ~ExistFlag
            mkdir(Dir);
        end
        FileName = fullfile(Dir,obj.F_SetFileName(obj.TickerSet{i},obj.EDate,obj.Exchange,thisFileType));
        %ReadTick.F_WriteMAT(FileName,Data)
        if ~p.Results.Overwrite && exist(FileName,'file')
            TitleStr = [obj.TickerSet{i},'文件已存在，不覆盖'];
            fprintf(FID,'%s\n',TitleStr);
            continue
        end
        Output=obj.DownloadData(obj.TickerSet{i},obj.TickerSet_Backup{i},obj.Exchange,obj.SDate,obj.EDate,API,varargin{:});
        if isempty(Output) || isempty(Output.Time)
            fprintf(FID,'%s\n','Empty');
            continue
        end
        %写入文件，如已经有文件存在，则覆盖
        thisStr = ['obj.F_Write_',upper(thisFileType),'(FileName,Output,1);'];
        eval(thisStr);
    catch Err
        TitleStr = ['日期时间：',datestr(now),'更新',obj.Product,'Tick数据失败：',Err.message];
        fprintf(FID,'%s\n',TitleStr);
        for j = 1:size(Err.stack,1)
            StrTemp = ['FunName：',Err.stack(j).name,'Line：',num2str(Err.stack(j).line)];
            fprintf(FID,'%s\n',StrTemp);
            error(StrTemp)
        end
    end
end
ElapseTime=toc(ticID);
TimeStr = [ '更新品种',obj.Product,'共耗时',num2str(ElapseTime), ' seconds(',num2str(ElapseTime/60), ' minutes)', ...
    '(',num2str(ElapseTime/60/60), 'hours)'];
fprintf(FID,'%s\n',TimeStr);

end