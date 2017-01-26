function Ind = F_TickFilter(~,Data)
Ind =( Data.Price~=0 & Data.Volume ~= 0); %strcmpi(Data.Type,'T'));
end