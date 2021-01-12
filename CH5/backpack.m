% function [sch,tolval,tolwei]=backpack(maxwei,weight,value)
% [s,v,t]=backpack(110,[1 10 20 40 45 22 30 55],[10 20 30 50 55 32 40 60])
clc;clear;
maxwei=110;                                   % 背包最大允许重量
weight=[1 10 20 40 45 22 30 55];    % 重量
value=[10 20 30 50 55 32 40 60];    % 价值
%
n=size(weight,2);sch=zeros(1,n);
p=value./weight;
[a,b]=sort(p);       % a从小到大排序后的向量,b是对应元素原始下标
% aa=[a;b]
b=b(n:-1:1);         % 逆转排列顺序从大到小
tw=0;                   % 已装入背包的物品重量
for i=1:n
    if (tw+weight(b(i)))<=maxwei   % 先装价值密度最大的(最好的)
        tw=tw+weight(b(i));
        sch(b(i))=1;
    end
end
tolwei=tw;  tolval=sum(value(find(sch))); 
Zv=sum(value(find(sch)))
Zw=sum(weight(find(sch)))
