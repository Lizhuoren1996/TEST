%% ����Ӧ�Ⱥ���
function plotFun(popmin,popmax)
dpop=0.1;
[X,Y] = meshgrid(popmin:dpop:popmax, popmin:dpop:popmax);
x=reshape(X,1,[]);        % ����άתΪһά
y=reshape(Y,1,[]);
xy=[x;y]';
z=myFun(xy);
Z=reshape(z,size(X));    % ��һάΪ��ά

subplot(3,1,[1,2]);  surf(X,Y,Z,'LineStyle','none');
hold on;
% view([45,55]);
view([45,15]);                      % ������ά�ӽ�
% axis([-10,10,-10,10,0,80]);  % ���������᷶Χ
title('��׼PSO�㷨�������ֵ');
end