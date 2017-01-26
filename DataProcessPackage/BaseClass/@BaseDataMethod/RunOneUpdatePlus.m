function FID=RunOneUpdatePlus(obj,API,FID,varargin)
%����Ĭ�ϲ���
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;   % ���������벻�����б�Ĳ���

addParameter(p,'Overwrite',true,@(x)islogical(x)||isnumerical(x));
addParameter(p,'FileType','csv',@(x)ischar(x));
parse(p,varargin{:});
%%
thisFileType = p.Results.FileType; %��ʱ�����е�FileType���趨Ϊcsv
if nargin<3
    FID=fopen([pwd,'\���ݸ�����־\',datestr(today,'yyyymmdd'),'.txt'],'at+');
end
ticID=tic;
for i=1:numel(obj.TickerSet)
    try
        disp(obj.TickerSet{i})
        TitleStr = ['���ڸ��µĴ��룺',obj.TickerSet{i}];
        fprintf(FID,'%s\n',TitleStr);
        [ExistFlag,Dir] = obj.F_FolderExist(floor(obj.EDate),obj.Exchange,obj.DataSource);
        if ~ExistFlag
            mkdir(Dir);
        end
        FileName = fullfile(Dir,obj.F_SetFileName(obj.TickerSet{i},obj.EDate,obj.Exchange,thisFileType));
        %ReadTick.F_WriteMAT(FileName,Data)
        if ~p.Results.Overwrite && exist(FileName,'file')
            TitleStr = [obj.TickerSet{i},'�ļ��Ѵ��ڣ�������'];
            fprintf(FID,'%s\n',TitleStr);
            continue
        end
        Output=obj.DownloadData(obj.TickerSet{i},obj.TickerSet_Backup{i},obj.Exchange,obj.SDate,obj.EDate,API,varargin{:});
        if isempty(Output) || isempty(Output.Time)
            fprintf(FID,'%s\n','Empty');
            continue
        end
        %д���ļ������Ѿ����ļ����ڣ��򸲸�
        thisStr = ['obj.F_Write_',upper(thisFileType),'(FileName,Output,1);'];
        eval(thisStr);
    catch Err
        TitleStr = ['����ʱ�䣺',datestr(now),'����',obj.Product,'Tick����ʧ�ܣ�',Err.message];
        fprintf(FID,'%s\n',TitleStr);
        for j = 1:size(Err.stack,1)
            StrTemp = ['FunName��',Err.stack(j).name,'Line��',num2str(Err.stack(j).line)];
            fprintf(FID,'%s\n',StrTemp);
            error(StrTemp)
        end
    end
end
ElapseTime=toc(ticID);
TimeStr = [ '����Ʒ��',obj.Product,'����ʱ',num2str(ElapseTime), ' seconds(',num2str(ElapseTime/60), ' minutes)', ...
    '(',num2str(ElapseTime/60/60), 'hours)'];
fprintf(FID,'%s\n',TimeStr);

end