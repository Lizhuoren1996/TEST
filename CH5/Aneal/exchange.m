function [fval_after,route_after,loc1,loc2]=exchange(route,d)   % �ı�·���ĺ���
n=length(d);
location=unidrnd(n,1,2);              % �������������Ȼ�������������·���ı�
loc1=min(location);loc2=max(location);
middle_route=fliplr(route(loc1:loc2));              % �ı�·����������Ϊ����ߵ�
route_after=[route(1:loc1-1) middle_route route(loc2+1:n)];  % �ı���·��
fval_after=value(route_after,d);

%1-14
%[24,13,31,21,30,14,6,11,27,10,19,18,20,1,      7,9,5,25,8,29,28,26,16,23,3,22,15,12,4,2,17]
%[1,20,18,19,10,27,11,6,14,30,21,31,13,24]
%[1,20,18,19,10,27,11,6,14,30,21,31,13,24,      7,9,5,25,8,29,28,26,16,23,3,22,15,12,4,2,17]