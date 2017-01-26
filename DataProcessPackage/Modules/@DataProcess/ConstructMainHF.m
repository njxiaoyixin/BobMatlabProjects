function HF  = ConstructMainHF(obj,InputFileType,Px,HF,BarDataSource)
% BarDataSourceΪ�������ݵ���Դ
if nargin<5 || isempty(BarDataSource)
%     BarDataSource = ['F:\',obj.DataProvider,'��������'];
BarDataSource = obj.HFDataSource;
end

if nargin <4 || isempty(HF)
    HF=struct();
end

HF.Close         = [];
HF.Time          = [];
HF.Volume        = [];
HF.ChangeCtrTime = [];

s = eval([obj.DataProvider,'Package.BarData']);
s.SetProperties('SDate',obj.SDate,'EDate',obj.EDate,'Product',obj.Product,'Exchange',obj.Exchange,'ProductType',obj.ProductType);
s.SetProperties('DataSource',BarDataSource);
s.UpdateTickerSet;
for j=1:numel(Px.Time)
    [ExistFlag,Dir] = s.F_FolderExist(Px.Time(j),s.Exchange,s.DataSource);
    FileName = [Dir,'\',s.F_SetFileName(Px.Contract{Px.MainPos(j,1)},Px.Time(j),s.Exchange,InputFileType)];
    if j>1
        %�ж��Ƿ񻻺�Լ
        if Px.MainPos(j,1) ~= Px.MainPos(j-1)
            %�������Լ�����¼����Լ��ʱ��
            HF.ChangeCtrTime = [HF.ChangeCtrTime;floor(Px.Time(j))+16/24];  %�̶���16�㻻��Լ
        end
    end
    if exist(FileName,'file')
        Data2=eval(['s.F_Read','_',upper(InputFileType),'(FileName)']);
        if isfield(Data2,'Data2')
            Data2 = Data2.Data2;
        end
        OriginFields   = fieldnames(Data2);
        InternalFields = F_GetInternalField(s, OriginFields);
        if numel(fieldnames(Data2))>=3
            Filter = obj.HFFilter(Data2.Time);
            %                         [STime,ETime]=s.F_GenerateTradeTime(Px.Time(j));
            %���˵�9:00-9:02 �Լ� 14:58-15:00������
            
            %                         Filter = ~((mod(Data2.Time,1)<(9/24+2/60/24) & mod(Data2.Time,1)>=9/24) | (mod(Data2.Time,1)>(15/24-2/60/24) & mod(Data2.Time,1)<=15/24));
            %                         Filter = Filter & Data2.Time >=STime & Data2.Time <=ETime;
            %д��һ���������������ڣ���������ʱ��
            for iField = 1:numel(OriginFields)
                HF.(InternalFields{iField}) = [HF.(InternalFields{iField});Data2.(OriginFields{iField})(Filter)];
            end
        end
        %                     if j>1
        %                         %�ж��Ƿ񻻺�Լ
        %                         if Px.MainPos(j,1) ~= Px.MainPos(j-1) && any(Filter)
        %                             %�������Լ�����¼����Լ��ʱ��
        %                             TempTime = Data2.Time(Filter);
        %                             HF.ChangeCtrTime = [HF.ChangeCtrTime;TempTime(1)];
        %                         end
        %                     end
    end
end
end