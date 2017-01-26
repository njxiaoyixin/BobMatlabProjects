%Connect to BBG Server
rehash
Dir = [pwd,'\���ݸ�����־\FTP������־\'];
if ~exist(Dir,'dir')
    mkdir(Dir)
end
fid=fopen([Dir,datestr(today,'yyyymmdd'),'.txt'],'wt+');%������־�ļ�����ʱ���и��ǣ������Ѿ����¹���
TitleStr= ['����ʱ�䣺',datestr(now),'    BBG FTP������־by Yixin Xiao'];
fprintf(fid,'%s\n',TitleStr);

fprintf(fid,'%s\n','Connecting to FTP Server...');
try
    FTP_Client = ftp('10.200.1.109:21','guest','');
catch Err
    fprintf(fid,'%s\n',Err.message);
    fclose('all');
    error('Connecting Error Exit!')
end
TitleStr= 'FTP���ӳɹ���';
fprintf(fid,'%s\n',TitleStr);

SDate = today();
EDate = today();
% SDate = datenum('2016-9-19');
% EDate = datenum('2016-9-19');
TargetFolder = 'F:\Bloomberg��������';
if ~exist(TargetFolder,'dir')
    mkdir(TargetFolder);
end
load GlobalTradeDay.mat
TradeDay = GlobalTradeDay.SH;

for Date = SDate:EDate
    TitleStr= ['��ʼ��������',datestr(Date),'������'];
    fprintf(fid,'%s\n',TitleStr);
    disp(datestr(Date))
    [Flag,Pos] = ismember(Date,TradeDay);
    if ~Flag
        TitleStr= '  �����Ǽ��ڣ�����Ҫ��Ϣ����';
        disp(TitleStr)
        fprintf(fid,'%s\n',TitleStr);
        continue
    end
    YearStr = num2str(year(Date));
    DateStr = datestr(Date,'yyyymmdd');
    w=dir(FTP_Client,YearStr);
    Check=0;
    for i=1:numel(w)
        if strcmpi(DateStr,w(i).name)
            %if Exist Download Folder
            TitleStr= '  �ļ�����!�ж��Ƿ��б����ļ�';
            fprintf(fid,'%s\n',TitleStr);
            %��������ļ����ڣ���ɾ�������ļ������и���
            LocalDir=[TargetFolder,'/',YearStr,'/',DateStr];
            if exist(LocalDir,'dir')
                TitleStr= '  �����ļ����ڣ�ɾ�������ļ�...';
                fprintf(fid,'%s\n',TitleStr);
                [SUCCESS,MESSAGE,MESSAGEID] = rmdir(LocalDir,'s');
                TitleStr= '  �����ļ�ɾ�����!��ʼ����...';
                fprintf(fid,'%s\n',TitleStr);
%             continue  %��������ļ����ڣ�������
            end
            %��ʼ����
            TitleStr= '  ��ʼ����...';
            fprintf(fid,'%s\n',TitleStr);
            try
                mget(FTP_Client,[YearStr,'/',w(i).name],TargetFolder);
            catch Err
                fprintf(fid,'%s\n',Err.message);
            end
            TitleStr= [DateStr,'  ������ϣ�'];
            fprintf(fid,'%s\n',TitleStr);
            Check=1;
            break
        end
    end
    if Check~=1
        TitleStr= '  ���������޸������ݣ������������أ�';
        fprintf(fid,'%s\n',TitleStr);
    end
end

TitleStr= '�����������ؽ���,�ر�����!';
fprintf(fid,'%s\n',TitleStr);
close(FTP_Client)
fclose('all');


subject = [datestr(now,31),'����Bar�������������'];
content = '���պ���Bar������������ϣ���鿴';
mail2me(subject,content)
