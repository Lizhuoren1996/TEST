function fval=value(route,d)  
% 求路径的长度，即目标函数
n=length(d);fval=0;
for i=1:n-1;fval=fval+d(route(i),route(i+1));end