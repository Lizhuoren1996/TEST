% function [sch,tolval,tolwei]=backpack(maxwei,weight,value)
% [s,v,t]=backpack(110,[1 10 20 40 45 22 30 55],[10 20 30 50 55 32 40 60])
clc;clear;
maxwei=110;                                   % ���������������
weight=[1 10 20 40 45 22 30 55];    % ����
value=[10 20 30 50 55 32 40 60];    % ��ֵ
%
n=size(weight,2);sch=zeros(1,n);
p=value./weight;
[a,b]=sort(p);       % a��С��������������,b�Ƕ�ӦԪ��ԭʼ�±�
% aa=[a;b]
b=b(n:-1:1);         % ��ת����˳��Ӵ�С
tw=0;                   % ��װ�뱳������Ʒ����
for i=1:n
    if (tw+weight(b(i)))<=maxwei   % ��װ��ֵ�ܶ�����(��õ�)
        tw=tw+weight(b(i));
        sch(b(i))=1;
    end
end
tolwei=tw;  tolval=sum(value(find(sch))); 
Zv=sum(value(find(sch)))
Zw=sum(weight(find(sch)))
