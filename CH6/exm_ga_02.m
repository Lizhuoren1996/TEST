function exm_ga_02
%%
clear all; clc;
xRange=[-10,-10,-5.12,-2, -5,    -3,  4.1
                  10, 10, 5.12, 2,   5, 12.1, 5.8];
num=6;
if num==6
    xRange=xRange(:,num:num+1);
else
    xRange=xRange(:,num);
end

% Start with the default options
options = gaoptimset;
% Modify options setting
options = gaoptimset(options,'PopInitRange', xRange); % 初始范围
options = gaoptimset(options,'PopulationSize', 100);      % 种群大小
options = gaoptimset(options,'CrossoverFraction', 0.9);  % 交叉概率
options = gaoptimset(options,'Generations', 100);           % 最大遗传代数
options = gaoptimset(options,'CrossoverFcn', {  @crossoverheuristic 0.9 });   % 交叉设置
options = gaoptimset(options,'MutationFcn', {  @mutationuniform 0.01 });   % 变异设置
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'PlotFcns', { @gaplotbestf });
[x,fval,exitflag,output,population,score] = ...
    ga(@myJFun,2,[],[],[],[],[],[],[],[],options);
disp(['x=[',num2str(x),']'])
disp(['函数最小值=',num2str(fval)]);

h=figure(1);clf;
set(h,'Name','遗传算法-求极值','Color','w','NumberTitle', 'off','WindowStyle','docked'); hold on;
plotJ(xRange);   hold on;
plot3(x(1),x(2),fval,'ro','markersize',10,'linewidth',2);
grid on;
view([45,-15]);
print('-clipboard','-dmeta')

%%
function z=myJFun(x)
%% 遗传算法性能指标要求最小值
switch 6
    case 1
        z=((x(1)^2+x(2)^2)^0.25)*((sin(50*((x(1)^2+x(2)^2)^0.1)))^2+1.0);
    case 2
        z=-0.5+((sin(sqrt(x(1)^2+x(2)^2)))^2 -0.5 ) / (1+0.001*( x(1)^2+x(2)^2))^2;
    case 3
        z=sum((x.*x-10*cos(2*pi*x)+10));
    case 4
        z=16+(x(1)^2-8*cos(2*pi*x(1)))+(x(2)^2-8*cos(2*pi*x(2)));
    case 5
        z= 20+x(1)^2 +x(2)^2 - 10* (cos(2* pi* x(1))+cos(2* pi* x(2)));
    case 6
        z=21.5+x(1)*sin(4*pi*x(1))+x(2)*sin(20*pi*x(2));
end

function plotJ(xRange)
%%
[n,m]=size(xRange);
xmax=xRange(2,1);xmin=xRange(1,1);
ymax=xRange(2,m);ymin=xRange(1,m);
dx=0.01;
[X,Y] = meshgrid(xmin:dx:xmax, ymin:dx:ymax);
[n,m]=size(X);
Z=zeros(n,m);
for i=1:n
    for j=1:m
        xx=[X(i,j),Y(i,j)];
        Z(i,j) = myJFun(xx);
    end
end
surf(X,Y,Z,'linestyle','none');
xlabel('x');  ylabel('y');  zlabel('z');
