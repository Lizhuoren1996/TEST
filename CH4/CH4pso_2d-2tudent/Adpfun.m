%% 适应度函数：最小值
function [y,fval]=Adpfun(x)
y    = myFun(x);
fval = y;   % 求原函数最小值 
% fval = 1/y;   % 求原函数最大值
end