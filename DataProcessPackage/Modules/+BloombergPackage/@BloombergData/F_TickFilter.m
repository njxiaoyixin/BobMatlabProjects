function Ind = F_TickFilter(~,Data)
Ind =(Data.Price~=0 & strcmpi(Data.Type,'TRADE')); %strcmpi(Data.Type,'T'));
end