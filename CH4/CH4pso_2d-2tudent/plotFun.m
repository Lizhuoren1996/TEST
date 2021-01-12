%% 画适应度函数
function plotFun(popmin,popmax)
dpop=0.1;
[X,Y] = meshgrid(popmin:dpop:popmax, popmin:dpop:popmax);
x=reshape(X,1,[]);        % 将二维转为一维
y=reshape(Y,1,[]);
xy=[x;y]';
z=myFun(xy);
Z=reshape(z,size(X));    % 将一维为二维

subplot(3,1,[1,2]);  surf(X,Y,Z,'LineStyle','none');
hold on;
% view([45,55]);
view([45,15]);                      % 调整三维视角
% axis([-10,10,-10,10,0,80]);  % 设置坐标轴范围
title('标准PSO算法，求最大值');
end