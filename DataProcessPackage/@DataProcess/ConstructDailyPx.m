function [ Px , PxActive]  = ConstructDailyPx(obj,varargin)
%����������Լ������ģʽ��
%1.��Ʒ�ڻ�ģʽ����Ĭ�ϣ����ݳɽ������жϣ�����һ����Լ��AverageDay�����ƽ���ɽ���������ǰһ����Լ���򻻺�Լ
%2.��ָ�ڻ�ģʽ���ڵ����յĵ����ڶ��컻��Լ����
% RollMode:'Comdty','Index'
% DailyDataSourceΪ�����ݵ���Դ
%                 DailyDataSource = ['F:\',obj.DataProvider,'������'];

%����Ĭ�ϲ���
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % ���������struct���е�properties�ֱ�۳����ӱ���
p.KeepUnmatched     = true;  % ���������벻�����б�Ĳ���

addParameter(p,'InputFileType','mat',@(x)ischar(x));
addParameter(p,'AverageDay',[],@(x)isnumerical(x));
valid_RollMode = {'Comdty','IndexFut'};
addParameter(p,'RollMode','Comdty',@(x)any(validatestring(upper(x),upper(valid_RollMode))));
addParameter(p,'AllowExpireMonth',false,@(x)islogical(x)||isnumerical(x));

s = eval([obj.DataProvider,'Package.DailyData']);
[InternalFields,~] = GenerateFields(s);
valid_fields       = InternalFields;
addParameter(p,'AllowedFields',InternalFields,@(x)any(ismember(upper(x),upper(valid_fields))));

parse(p,varargin{:});

InputFileType    = p.Results.InputFileType;
AverageDay       = p.Results.AverageDay;
RollMode         = p.Results.RollMode;
AllowExpireMonth = p.Results.AllowExpireMonth;
AllowedFields    = p.Results.AllowedFields;

%-----------
DailyDataSource = obj.PxDataSource;
%------------

if isempty(AverageDay)
    if strcmpi(RollMode,'Comdty')
        AverageDay = 5;
    else
        AverageDay = 1;
    end
end
% AverageDay �趨ʱ�䴰�ڲ���
ThisProduct = strtrim(obj.Product); %��ֹ�������пո����
%obj��Ҫ�еı�����SDate,EDate,Product,Exchange,ProductType
%��Ҫ������ReadDaily��Divided��Concat

s.SetProperties('SDate',obj.SDate,'EDate',obj.EDate,'Product',obj.Product,'Exchange',obj.Exchange,'ProductType',obj.ProductType);
s.SetProperties('DataSource',DailyDataSource);
s.UpdateTickerSet;

%�Ƚ�������ȫ������һ��Struct
Px=struct();
ExistFlag = zeros(numel(s.TickerSet),1);
Px.Time=[];
for j=1:numel(s.TickerSet)
    Dir = [s.DataSource,'\',ThisProduct];
    FileName = [Dir,'\',s.F_SetFileName(s.TickerSet{j},[],s.Exchange,InputFileType)];
    if exist(FileName,'file')
        ExistFlag(j)=1;
        Data=eval(['s.F_Read','_',upper(InputFileType),'(FileName)']);
        Ind = floor(Data.Time) >= obj.SDate & floor(Data.Time) <= obj.EDate;
        Px.Time=union(Px.Time,floor(Data.Time(Ind)));  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
end

if isempty(Px.Time)
    warning(['No Data Exist for product: ',obj.Product])
    Px       = [];
    PxActive = [];
    return
end

OriginFields = fieldnames(Data);
InternalFields= F_GetInternalField(s, OriginFields);
for iField=1:numel(OriginFields)
    if ~strcmpi(OriginFields{iField},'Time')
        Px.(InternalFields{iField}) = nan(numel(Px.Time),sum(ExistFlag));
    end
end
Px.Contract=cell(1,sum(ExistFlag));
Px.ContractMonth=ones(1,sum(ExistFlag));
k=1;
for j=1:numel(s.TickerSet)
    Dir = [s.DataSource,'\',ThisProduct];
    FileName = [Dir,'\',s.F_SetFileName(s.TickerSet{j},[],s.Exchange,InputFileType)];
    if ExistFlag(j)
        %                     load(FileName)
        Data=eval(['s.F_Read','_',upper(InputFileType),'(FileName)']);
        [Flag,Pos]=ismember(floor(Data.Time),Px.Time);
        if any(Flag)
            for iField=1:numel(OriginFields)
                if ~strcmpi(OriginFields{iField},'Time')
                    Px.(InternalFields{iField})(Pos(Pos>0),k) = Data.(OriginFields{iField})(Flag);
                end
            end
            %             Px.Close(Pos(Pos>0),k)=Data.Close(Flag);
            %             Px.Open(Pos(Pos>0),k)=Data.Open(Flag);
            %             Px.High(Pos(Pos>0),k)=Data.High(Flag);
            %             Px.Low(Pos(Pos>0),k)=Data.Low(Flag);
            %             Px.Volume(Pos(Pos>0),k)=Data.Volume(Flag);
        end
        Px.Contract{k} = s.TickerSet{j};
        Px.ContractMonth(k) = s.ContractMonth(j);
        k=k+1;
    end
end

Px.Value = Px.Volume .*  Px.Close;

%-----------------------����������Լ,������,�ٴ�������Լ��־--------------------
if isempty(Px.Time)
    warning('Px is empty!')
    return
end
Px.MainPos = ones(numel(Px.Time),3);
MaxValue   = zeros(3,1);
for k=1:3
    thisMainPos = 1;
    if size(Px.Value,2) > 1
        for j=AverageDay:numel(Px.Time)
            AvgValue = nanmean(Px.Value(j-AverageDay+1:j,:),1);
            AvgValue(sum(isnan(Px.Value(j-AverageDay+1:j,:)),1) > AverageDay/2) = -1;
            
            SortedAvgValue = sort(AvgValue,2,'descend');
            % Ĭ�����������������Լ��ٴ������������󻻺�Լ�������������ٴ�����������ǰ��
            MaxValue(k)  = find(AvgValue == SortedAvgValue(k),1);
            if any(MaxValue(k) > Px.MainPos(j,k))
                thisMainPos = MaxValue(k);
            end
            
            % ������ܽ��뽻����
            if ~AllowExpireMonth
                ExpireMonth = datenum(num2str(Px.ContractMonth(thisMainPos),'%04.0f'),'yymm');
                s = k;
                while Px.Time(j)>=ExpireMonth-1 %�����˽����£�����
                    s  = s+1;
                    MaxValue(k)  = find(AvgValue == SortedAvgValue(s),1);
                    if any(MaxValue(k) > Px.MainPos(j,k))
                        thisMainPos = MaxValue(k);
                    end
                    ExpireMonth = datenum(num2str(Px.ContractMonth(thisMainPos)),'yymm');
                end
            end
            Px.MainPos(j:end,k) = thisMainPos;
        end
        Px.MainPos(1:AverageDay-1,k)= Px.MainPos(AverageDay,k);
    end
    Px.MainMonth(:,k)   = Px.ContractMonth(Px.MainPos(:,k))';
end

% �������ݽ�������
PxActive = struct();
PxActive.Time = Px.Time;
for i=1:numel(Px.Time)
    for iField=1:numel(OriginFields)
        if ~strcmpi(OriginFields{iField},'Time') && ismember(upper(OriginFields{iField}),upper(AllowedFields))
            PxActive.(OriginFields{iField})(i,1) = Px.(OriginFields{iField})(i,Px.MainPos(i,1));
        end
    end
end
