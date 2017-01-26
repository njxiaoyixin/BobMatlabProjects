function PlotResult(obj)
figure(1)
title('Cumulative Daily Return')
plot(obj.DateVec,cumsum(obj.DailyRetVec))
%             legend('location','best');
datetick('x','yyyy-mm-dd')
end