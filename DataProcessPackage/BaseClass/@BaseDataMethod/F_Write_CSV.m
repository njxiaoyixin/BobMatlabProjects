function Status        = F_Write_CSV(obj,FileName,Data,ReadOption,varargin)
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���

addRequired(p,'FileName',@ischar)
addRequired(p,'Data',@isstruct)
addOptional(p,'ReadOption',@(x) x==1 || x==2)
addParameter(p,'AllowCustomFields',false,@(x)islogical(x)||isnumeric(x))
parse(p,FileName,Data,ReadOption,varargin{:})
AllowCustomFields = p.Results.AllowCustomFields;

%Data��һ��struct,�ں�Price,volume��9������
Status = 1;
%ReadOption: ����д���ļ��Ĳ���
%             '1'�򿪻��ߴ����ļ���������ԭ����
%             '2'�򿪻��ߴ����ļ��������ļ��������������
if nargin<3
    %     ReadOptionĬ������Ϊ1
    ReadOption=1;
end

switch ReadOption
    case 1
        SubReadOption = 'w+t';
    case 2
        SubReadOption = 'a+t';
    case 3
        SubReadOption = 'rt';
end
%���ļ�
%����������ǣ�������ֱ���˳�
if strcmpi(SubReadOption,'rt') && exist(FileName,'file')
    return
else
    OriginFields = fieldnames(Data);
    [ Types,~,Fields ]= obj.F_GetFieldType(OriginFields,'AllowCustomFields',AllowCustomFields);
    if exist(FileName,'file') && ReadOption==2
        %����ļ��Ѿ����ڣ���д�������
        FID         = fopen(FileName,SubReadOption);
    else
        %����ļ������������SubReadOptiond���ļ������ܻ��½��ļ���
        FID         = fopen(FileName,SubReadOption);
        if FID~=-1
            %����½����ļ�����д�������
            for i=1:(numel(Fields)-1)
                fprintf(FID,'%s,',Fields{i});
            end
            fprintf(FID,'%s\n',Fields{end});
        else
            %���û���½��ļ������˳�
            return
        end
    end
end

%д������

% FieldTable = {'Time','Price','Volume','Open_Int','SP1','SV1','BP1','BV1','isBuy','Type','Open','High','Low','Close','Value','NumTick','Amount','Pre_Close','OI_Chg'};
% FieldType  = {'s','9.4f','12.0f','12.0f','9.4f','8.0f','9.4f','8.0f','d','s','9.4f','9.4f','9.4f','f','14.0f','10.0f','14.0f','9.4f','12.0f'};

for i=1:numel(Data.Time)
    if ~iscell(Data.Time(1))
        fprintf(FID,'%s,',datestr(Data.Time(i),'yyyy-mm-dd HH:MM:SS'));
    else
        fprintf(FID,'%s,',Data.Time{i});
    end
    
    for j=1:(numel(Fields)-1)
        if ~strcmpi(Fields{j},'Time')
            fprintf(FID,['%',Types{j},','],Data.(OriginFields{j})(i));
        end
    end
    fprintf(FID,['%',Types{end},'\n'],Data.(OriginFields{end})(i));
end
fclose(FID);
end