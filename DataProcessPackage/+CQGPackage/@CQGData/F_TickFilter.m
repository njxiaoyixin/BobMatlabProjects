function Ind = F_TickFilter(~,Data)
Ind =(Data.Price~=0 & Data.Type=='T'); %strcmpi(Data.Type,'T'));
end