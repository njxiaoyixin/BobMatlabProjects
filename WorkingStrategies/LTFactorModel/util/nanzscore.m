function [ z , nm, ns ] = nanzscore( x )  
%[ z ] = nanzscore( x ),ignoring NaNs  
%   类似于标准化函数[ z ] = zscore( x ),忽略NaNs  
% Author:wuxuping,Date:2013-09-21  
  
nm=nanmean(x);  
ns=nanstd(x);  
  
[xrow,xcolumn]=size(x);  
  
if ((xrow>1 )&&(xcolumn >1))  
    %如果是多行多列的矩阵  
    z=zeros(size(x));  
    for m=1:xrow  
        for n=1:xcolumn  
            z(m,n) = (x(m,n)- nm(n))./ns(n);  
        end  
    end  
else  
    %如果是单行或单列的向量  
    if (xrow==1)  
        for m=1:numel(x)  
            z(m) = (x(m)- nm)./ns;%行向量  
        end  
    else  
        for m=1:numel(x)  
            z(m,1) = (x(m)- nm)./ns;%列向量  
        end  
    end      
end  