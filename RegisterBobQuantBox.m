function RegisterBobQuantBox()
p1 = mfilename('fullpath');
i = strfind(p1,'\');
p1 = p1(1:i(end));

addpath(genpath(p1))
savepath
end