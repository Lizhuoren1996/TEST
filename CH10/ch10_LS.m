%%  ��С����һ����ɷ�
%------------------------------------------------
% ��1��flag=1  ����ϵͳ
% z(k)-1.5z(k-1)+0.7z(k-2)=u(k-1)+0.5u(k-2)+v(k)
%------------------------------------------------
% ��1��flag=2  ʵ��ѹ��ϵͳ
% PV^(alf)=(beta)  --->logP=-(alf)logV+log(beta)
%------------------------------------------------
close all; clc;  clear;
flag = 1;

[u,z]=getData(flag);                               % ��ȡ����������ݶ�
[HL,ZL]=createSampleMatrix(u,z,flag);  % ������������
c=LS(HL,ZL);                                            % ��С����һ����ɷ�
showResult(c,flag);                                 % ��ʾ��ʶ���

%%   �ӳ���
function y=LS(HL,ZL)
%% ��С����һ����ɷ�
c1=HL'*HL; 
c2=inv(c1); 
c3=HL'*ZL; c=c2*c3; 
y=c;
end
function [in,out]=getData(flag)
%% ���������������
switch flag
    case 1
        u=[-1,1,-1,1,1,1,1,-1,-1,-1,1,-1,-1,1,1]; % �����ź�Ϊһ�����ڵ�M����
        z=zeros(1,16); % ��������۲�ֵ�ĳ���
        for k=3:16 
            z(k)=1.5*z(k-1)-0.7*z(k-2)+u(k-1)+0.5*u(k-2); %���������ֵ��Ϊ�۲�ֵ
        end
        subplot(2,1,1) ;   stem(u); 
        subplot(2,1,2) ;  plot(1:16,z) ;hold on;    stem(z);
    case 2
        u=[54.3,61.8,72.4,88.7,118.6,194.0]';    
        z=[61.2,49.5,37.6,28.4,19.2,10.1]';         
end     
in=u;
out=z;
end
function [HL,ZL]=createSampleMatrix(u,z,flag)
%% ������������͹۲����
switch flag
    case 1
        HL=[-z(2) -z(1) u(2) u(1);
            -z(3) -z(2) u(3) u(2);
            -z(4) -z(3) u(4) u(3);
            -z(5) -z(4) u(5) u(4);
            -z(6) -z(5) u(6) u(5);
            -z(7) -z(6) u(7) u(6);
            -z(8) -z(7) u(8) u(7);
            -z(9) -z(8) u(9) u(8);
            -z(10) -z(9) u(10) u(9);
            -z(11) -z(10) u(11) u(10);
            -z(12) -z(11) u(12) u(11);
            -z(13) -z(12) u(13) u(12);
            -z(14) -z(13) u(14) u(13);
            -z(15) -z(14) u(15) u(14)];  % ����������HL��ֵ

        ZL=[z(3);z(4);z(5);z(6);z(7);z(8);z(9);z(10);z(11);z(12);z(13);z(14);z(15);z(16)]; % ����������zL��ֵ
    case 2
        ZL=log(z);                       % ��ZL��ֵ
        HL=[-log(u(1)),1;
            -log(u(2)),1;
            -log(u(3)),1;
            -log(u(4)),1;
            -log(u(5)),1;
            -log(u(6)),1];               % ��HL��ֵ
end
end
function showResult(c,flag)
%% ��ʾ��� 
switch flag
    case 1
        str=sprintf('a1=%.4f;a2=%.4f;b1=%.4f;b2=%.4f',c(1),c(2),c(3),c(4));
        disp(str);
        %  a1=c(1), a2=c(2), b1=c(3), b2=c(4) %�� �з��������ʾa1 ��a2�� b1�� b2
    case 2
        str=sprintf('alpha=%.4f;beta=%.4f',c(1),exp(c(2)));
        disp(str);
       %  alpha=c(1)           % Ϊc4�ĵ�1��Ԫ��
       %  beta=exp(c(2))    % Ϊ����Ȼ��Ϊ�׵�c4�ĵ�2��Ԫ�ص�ָ��
end
end