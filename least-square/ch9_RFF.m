function f=ch9_RFF()
% ����������С���˵����㷨��ʱ��ϵͳ
% y(k)+a(k)y(k-1)=b(k)u(k-1)+e(k)
% 0<k<300 a(k)=0.8,b(k)=0.5
% k>300 a(k)=0.6,b(k)=0.3
% e(k)Ϊ���ֵ������Ϊ0.1�ĸ�˹������

close all;
clear;
clc;

u=[-1,1,-1,1,1,1,1,-1,-1,-1,1,-1,-1,1,1]*10;  % �ɵ��������
p0=1000^2*eye(2);
tol=1e-3;
it=1000;  %
eflag=1;  % ������

r=1;     %��������
[theta1,tk_hist1]=RFF(u,1,p0,tol,it,eflag);
[theta099,tk_hist099]=RFF(u,0.99,p0,tol,it,eflag);
[theta09,tk_hist09]=RFF(u,0.9,p0,tol,it,eflag);

figure(1);
s1=size(tk_hist1);
s099=size(tk_hist099);
s09=size(tk_hist09);
size_tk=max([s1(2),s099(2),s09(2)]);
for i=2:10:size_tk
    hold on;
    plot([0 300 300 size_tk],[0.8 0.8 0.6 0.6],'--k');
    plot([0 300 300 size_tk],[0.5 0.5 0.3 0.3],'--k');
    % title(string);
    plot(tk_hist1(:,1:i)','r','linewidth',2);
    plot(tk_hist099(:,1:i)','b','linewidth',2);
    plot(tk_hist09(:,1:i)','m','linewidth',2);
    
    pause(0.2);
    hold off
end

% ����������С���˷�
function [theta,tk_hist]=RFF(u,r,p0,tol,it,eflag)
% uΪ����4��M����
% rΪ��������
% p0ΪP(k)�����ʼֵ
% tol����ʶ�����ĳ�ֵ
% theta�������ʶ����
% eflagΪ�������ƣ�1=��������0=������
if eflag==1
    v=randn(1,10000);     
    a=0;                            % ������ֵ
    b=0.1;                         % ��������
    v=v/std(v);
    v=v-mean(v);
    v=a+b*v;
    string=['��ֵΪ' num2str(a) '����Ϊ' num2str(b) '������������'...
        '����r=' num2str(r) 'ʱϵͳ��ʶ����'];
else
    v=zeros(1,10000);
    string=['����������������r=' num2str(r) 'ʱϵͳ��ʶ����'];
end
y(1)=v(1);                            % y(1)��z(2)����0������������͵�������
ab1=[0.8 0.5]';                    % ģ�Ͳ������ڹ���hk
ab2=[0.6 0.3]';    
tk=tol*ones(2,1);              
pk=p0;
k=2;                                  % ������������
tk_hist=tk;                         % �������ʶ�����������
while(k<it) 
    if mod(k,15)~=0           % k>15ʱM���е�ȡֵ
        u(k)=u(mod(k,15));
    else
        u(k)=u(15);
    end
    hk=[-y(k-1) u(k-1)]';
    if k<300
        y(k)=hk'*ab1+v(k);
    else
        y(k)=hk'*ab2+v(k);
    end
    kk=pk*hk/(hk'*pk*hk+r);    % PPT-ʽ68
    pk=(eye(2)-kk*hk')*pk/r;   
    tk=tk+kk*(y(k)-hk'*tk);
    tk_hist=[tk_hist tk];             % ����������
    k=k+1;
end
theta=[tk_hist(:,300) tk_hist(:,end)];

