function fval=value(route,d)  
% ��·���ĳ��ȣ���Ŀ�꺯��
n=length(d);fval=0;
for i=1:n-1;fval=fval+d(route(i),route(i+1));end