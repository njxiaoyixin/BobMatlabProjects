function HF  = ConstructMainHF(obj,InputFileType,Px,HF,BarDataSource)
% BarDataSource为分钟数据的来源
if nargin<5 || isempty(BarDataSource)
%     BarDataSource = ['F:\',obj.DataProvider,'分钟数据'];
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
        %判断是否换合约
        if Px.MainPos(j,1) ~= Px.MainPos(j-1)
            %如果换合约了则记录换合约的时间
            HF.ChangeCtrTime = [HF.ChangeCtrTime;floor(Px.Time(j))+16/24];  %固定在16点换合约
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
            %过滤掉9:00-9:02 以及 14:58-15:00的数据
            
            %                         Filter = ~((mod(Data2.Time,1)<(9/24+2/60/24) & mod(Data2.Time,1)>=9/24) | (mod(Data2.Time,1)>(15/24-2/60/24) & mod(Data2.Time,1)<=15/24));
            %                         Filter = Filter & Data2.Time >=STime & Data2.Time <=ETime;
            %写出一个函数，给定日期，给出交易时间
            for iField = 1:numel(OriginFields)
                HF.(InternalFields{iField}) = [HF.(InternalFields{iField});Data2.(OriginFields{iField})(Filter)];
            end
        end
        %                     if j>1
        %                         %判断是否换合约
        %                         if Px.MainPos(j,1) ~= Px.MainPos(j-1) && any(Filter)
        %                             %如果换合约了则记录换合约的时间
        %                             TempTime = Data2.Time(Filter);
        %                             HF.ChangeCtrTime = [HF.ChangeCtrTime;TempTime(1)];
        %                         end
        %                     end
    end
end
end