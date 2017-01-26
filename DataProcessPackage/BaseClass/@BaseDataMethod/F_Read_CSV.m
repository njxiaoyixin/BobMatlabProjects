function [Data,Status] = F_Read_CSV(obj,FileName,Header)
FieldTable = {'Time','Price','Volume','Open_Int','SP1','SV1','BP1','BV1','isBuy','Type','Open','High','Low','Close','Value','NumTick','Amount','Pre_Close','OI_Chg'};
FieldType  = ['s','f','u','u','f','u','f','u','d','s','f','f','f','f','u','u','u','f','u'];
Status = 1;
fid = fopen(FileName,'rt');
if fid ==-1
    Status=-1;
    return
end
ignore          = textscan(fid,'%s',1,'delimiter','\n');
if numel(ignore)<1
    Data = [];
    Status = 0;
end
s1              = ignore{:};
LineHeader      = s1{:};
Header          = regexp(LineHeader,',','split');
fmtstr          = [];
if any(strcmpi('Time',Header) | strcmpi('Date',Header))
    if any(strcmpi('OI',Header))%�ѱ����е�OIת��ΪOpen_Int
        Header{(strcmpi('OI',Header))}='Open_Int' ;
    end
    for i=1:numel(Header)
        [ ~,thisReadType,InternalField ]= obj.F_GetFieldType(Header{i});
        fmtstr=[fmtstr,'%',thisReadType];
        if strcmp(Header{i},InternalField)
            Header{i}=InternalField;
        end
    end
else
    if nargin < 3
        error('There is no Header in the file, please specify the header!')
    end
end
Raw             = textscan(fid,fmtstr,'delimiter',',\n');
% ���ܳ��������м���һ�б��������������������⣩������֮�������û�ж�ȡ����ʱ��Ҫ������һ�����ݣ�
% ��������ȡ�����ڻ�δ������
fclose(fid);
Data            = struct();
for i =1:numel(Header)
    if (strcmpi(Header{i},'Time') || strcmpi(Header{i},'Date'))
        %��Date��TimeͳһΪTime
        if ~isempty(Raw{i})
            Data.Time = datenum(Raw{i});
        else
            Data.Time = [];
        end
    else
        if numel(Raw)<i
            return
        end
        Data.(Header{i}) = Raw{i};
    end
end

end