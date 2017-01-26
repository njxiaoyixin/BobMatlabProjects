function FactorInfo = UpdateEDBCodeMap()
FileName   = 'F:\工作文件\策略研究\商品期货\商品期货多因子\因子库挖掘\LongTermFactor_1.0_20170105.xlsx';
SheetName  = 'Summary';

[~,~,Raw]=xlsread(FileName,SheetName);
Raw = CleanCellNan(Raw);
Universe.ProductName  = Raw(2:end,1);
Universe.Product      = Raw(2:end,2);
Universe.Ticker       = Raw(2:end,3);
Universe.Exchange     = Raw(2:end,4);
Universe.Industry     = Raw(2:end,5);
Universe.Control      = cell2mat(Raw(2:end,6));
Universe.Indicator    = cell2mat(Raw(2:end,7));

filter = Universe.Control>0;
UniverseFields = fieldnames(Universe)';
for field = UniverseFields
    Universe.(field{:}) = Universe.(field{:})(filter);
end

%　读取Universe里面的每个品种对应的页面
k = 1;
for iProduct = 1:numel(Universe.ProductName)
    productName = Universe.ProductName{iProduct};
    SheetName   = productName;
    try
        [~,~,Raw]=xlsread(FileName,SheetName);
        Raw = CleanCellNan(Raw);
        Product(k).product   = Universe.Product{iProduct};
        Product(k).ticker    = Universe.Ticker{iProduct};
        Product(k).exchange  = Universe.Exchange{iProduct};
        Product(k).industry  = Universe.Industry{iProduct};
        Product(k).control   = Universe.Control(iProduct);
        
        Indicator(k).product  = Product(k).product;
        Indicator(k).indicator  = Universe.Indicator(iProduct);
        
        iBase = 1;
        iAdv = 1;
        for iFactor = 1:(size(Raw,1)-1)
            thisData = struct();
            if ~isempty(Raw{iFactor+1,1})
                thisData.indicator        = Raw{iFactor+1,1};
                thisData.factorName       = Raw{iFactor+1,2};
                thisData.funcName         = Raw{iFactor+1,3};
                thisData.ticker           = Raw{iFactor+1,4};
                thisData.field            = Raw{iFactor+1,5};
                thisData.freq             = Raw{iFactor+1,6};
                thisData.publishDay       = Raw{iFactor+1,7};
                thisData.publishDayMetric = Raw{iFactor+1,8};
                thisData.remarks          = Raw{iFactor+1,9};
                Fields = fieldnames(thisData);
                if ~strcmpi(thisData.funcName,'custom')
                    for iField = 1:numel(Fields)
                        Product(k).FundaFactors.BaseFactor(iBase,1).(Fields{iField}) = thisData.(Fields{iField});
                    end
                    iBase=iBase+1;
                elseif strcmpi(thisData.funcName,'custom') % Advanced Factors
                    for iField = 1:numel(Fields)
                        Product(k).FundaFactors.AdvFactor(iAdv,1).(Fields{iField}) = thisData.(Fields{iField});
                    end
                    iAdv=iAdv+1;
                else
                end
            end
        end
        k=k+1;
    catch Err
        if any(regexpi(Err.message,'未找到工作表'))
            continue
        end
    end
end

productName = 'GeneralFactors';
SheetName   = productName;
try
    [~,~,Raw]=xlsread(FileName,SheetName);
    Raw = CleanCellNan(Raw);
    iBase=1;
    iAdv = 1;
    for iFactor = 1:(size(Raw,1)-1)
        thisData = struct;
        if ~isempty(Raw{iFactor+1,1})
            thisData.indicator  = Raw{iFactor+1,1};
            thisData.factorName = Raw{iFactor+1,2};
            thisData.field      = Raw{iFactor+1,3};
            thisData.funcName   = Raw{iFactor+1,4};
            thisData.remarks    = Raw{iFactor+1,5};
            Fields = fieldnames(thisData);
            if ~strcmpi(thisData.funcName,'custom')
                for iField = 1:numel(Fields)
                    GeneralFactors.TechFactors.BaseFactor(iBase,1).(Fields{iField}) = thisData.(Fields{iField});
                end
                iBase = iBase+1;
            elseif  strcmpi(thisData.funcName,'custom')  % Advanced Tech Factors
                for iField = 1:numel(Fields)
                    GeneralFactors.TechFactors.AdvFactor(iAdv,1).(Fields{iField}) = thisData.(Fields{iField});
                end
                iAdv = iAdv+1;
            else
            end
        end
    end
catch Err
    if ~any(regexpi(Err.message,'未找到工作表'))
        throw(Err)
    end
end
FactorInfo.Indicator = Indicator;
FactorInfo.Product = Product;
FactorInfo.GeneralFactors = GeneralFactors;

xml_write('Config\EDBCodeMap.xml',FactorInfo)
end

function RawOut = CleanCellNan(Raw)
RawOut = Raw;
for i=1:size(Raw,1)
    for j=1:size(Raw,2)
        if any(isnan(Raw{i,j}))
            RawOut{i,j}=[];
        end
    end
end
end