function Dates = F_GenerateDates(obj)
Date      = obj.SDate:obj.EDate;
MonthSet  = month(Date);
YearSet   = year(Date);
Dates=unique(datenum([YearSet',MonthSet',ones(numel(MonthSet),1)]))';
end