%example11_4
%����Akaike׼�����ģ�͵Ľ״�
%�����ǣ����̱�ʶ���廪��ѧ�����磻P348����13.6
%===================================
close all;   clear;   clc
%% ==========����M������Ϊ����===============
x=[0 1 0 1 1 0 1 1 1]; %initial value
n=1003; %nΪ������Ŀ
M=[]; %���M����
for i=1:n
temp=xor(x(4),x(9));
M(i)=x(9);
for j=9:-1:2
x(j)=x(j-1);
end
x(1)=temp;
end
%% ��������˹��������ϵͳ���
v=randn(1,1004);
z=[];
z(1)=-1;
z(2)=0;
L=1000;
for i=3:L+4
z(i)=1.5*z(i-1)-0.7*z(i-2)+M(i-1)+0.5*M(i-2)+v(i);
end
%%
% ģ�ͽ״�n=1
for i=1:L
H1(i,1)=z(i);;
H1(i,2)=M(i);
end
estimate1=inv(H1'*H1)*H1'*z(2:1001)';
D1=(z(2:1001)'-H1*estimate1)'*(z(2:1001)'-H1*estimate1)/L;
AIC1=L*log(D1)+4*1;
% ģ�ͽ״�n=2
for i=1:L
H2(i,1)=z(i+1);;
H2(i,2)=z(i);
H2(i,3)=M(i+1);
H2(i,4)=M(i);
end
estimate2=inv(H2'*H2)*H2'*z(3:1002)';
D2=(z(3:1002)'-H2*estimate2)'*(z(3:1002)'-H2*estimate2)/L;
AIC2=L*log(D2)+4*2;
% ģ�ͽ״�n=3
for i=1:L
H3(i,1)=z(i+2);
H3(i,2)=z(i+1);
H3(i,3)=z(i);
H3(i,4)=M(i+2);
H3(i,5)=M(i+1);
H3(i,6)=M(i);
end
estimate3=inv(H3'*H3)*H3'*z(4:1003)';
D3=(z(4:1003)'-H3*estimate3)'*(z(4:1003)'-H3*estimate3)/L;
AIC3=L*log(D3)+4*3;
% ģ�ͽ״�n=4
for i=1:L
H4(i,1)=z(i+3);
H4(i,2)=z(i+2);
H4(i,3)=z(i+1);
H4(i,4)=z(i);
H4(i,5)=M(i+3);
H4(i,6)=M(i+2);
H4(i,7)=M(i+1);
H4(i,8)=M(i);
end
estimate4=inv(H4'*H4)*H4'*z(5:1004)';
D4=(z(5:1004)'-H4*estimate4)'*(z(5:1004)'-H4*estimate4)/L;
AIC4=L*log(D4)+4*4;
%% ��ͼ
plot(1:4,[AIC1 AIC2 AIC3 AIC4])
title('AIC�ж�ģ�ͽ״�')
xlabel('�״�')
ylabel('AIC')