function [Y_Outsample_forecast,accuracy_insample]=F_ExecForcast(X_Insample,Y_Insample,X_Outsample)
% Y is the return of products in this case (Every Product has n Days *1 vector)
Filter = ~isnan(Y_Insample);
% [b,bint,r,rint,stats] = regress(Y(Filter),[score(Filter,:),ones(size(score(Filter,:),1),1)]);
[b,~,STATS] =glmfit(X_Insample(Filter,:),Y_Insample(Filter),'binomial', 'link', 'logit');
Y_Insample_forecast = glmval(b,X_Insample(Filter,:), 'logit');
idx = Y_Insample_forecast>=0.5;
Y_Insample_forecast(idx) = 1;
Y_Insample_forecast(~idx) = 0;
accuracy_insample = sum(Y_Insample_forecast==Y_Insample(Filter))/numel(Y_Insample_forecast);
Y_Outsample_forecast = glmval(b,X_Outsample, 'logit');
end