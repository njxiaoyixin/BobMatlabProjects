function [ Px , PxActive]  = ConstructDailyPx(obj,varargin)
%连接主力合约有两种模式：
%1.商品期货模式：（默认）根据成交额来判断，当下一个合约在AverageDay里面的平均成交量都超过前一个合约，则换合约
%2.股指期货模式：在到期日的倒数第二天换合约（）
% RollMode:'Comdty','Index'
% DailyDataSource为日数据的来源
%                 DailyDataSource = ['F:\',obj.DataProvider,'日数据'];

%设置默认参数
p                   = inputParser;
p.CaseSensitive     = false;
p.StructExpand      = true;   % 允许将输入的struct当中的properties分别扣出成子变量
p.KeepUnmatched     = true;  % 不允许输入不属于列表的参数

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
% AverageDay 设定时间窗口参数
ThisProduct = strtrim(obj.Product); %防止名字中有空格出现
%obj需要有的变量：SDate,EDate,Product,Exchange,ProductType
%需要先运行ReadDaily的Divided和Concat

s.SetProperties('SDate',obj.SDate,'EDate',obj.EDate,'Product',obj.Product,'Exchange',obj.Exchange,'ProductType',obj.ProductType);
s.SetProperties('DataSource',DailyDataSource);
s.UpdateTickerSet;

%先将日数据全部连成一个Struct
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

%-----------------------构造主力合约,次主力,再次主力合约标志--------------------
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
            % 默认是主力、次主力以及再次主力都是往后换合约，即次主力和再次主力不会往前走
            MaxValue(k)  = find(AvgValue == SortedAvgValue(k),1);
            if any(MaxValue(k) > Px.MainPos(j,k))
                thisMainPos = MaxValue(k);
            end
            
            % 如果不能进入交割月
            if ~AllowExpireMonth
                ExpireMonth = datenum(num2str(Px.ContractMonth(thisMainPos),'%04.0f'),'yymm');
                s = k;
                while Px.Time(j)>=ExpireMonth-1 %超过了交割月，往后换
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

% 将日数据进行连接
PxActive = struct();
PxActive.Time = Px.Time;
for i=1:numel(Px.Time)
    for iField=1:numel(OriginFields)
        if ~strcmpi(OriginFields{iField},'Time') && ismember(upper(OriginFields{iField}),upper(AllowedFields))
            PxActive.(OriginFields{iField})(i,1) = Px.(OriginFields{iField})(i,Px.MainPos(i,1));
        end
    end
end
