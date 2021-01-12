% function POS_2d
%% 了解粒子数与代数对结果的影响
clf; clear all; clc;
h_Fig=0;     % FIG句柄
stop = uicontrol('style','toggle','string','stop', ...
    'background','white');   % FIG上设置stop按钮

%% 参数设置
% 待求解函数的参数：与待求解函数有关
par_num=2;               % 参数个数     
popmax=5;popmin=-5;      % 参数取值范围5.12
% PSO参数：与PSO算法有关
c1=2;c2=2;
w_max=0.9;w_min=0.4;     % 惯性权重的初始及终止值
vmax=1;vmin=-1;          % 参数范围
% 优化参数
max_iterm=100;sizepop=25;           % 代数，粒子数
 
plotFun(popmin,popmax);             % 画函数图

%% 粒子初始化
for i=1:sizepop                                   
    pop(i,:)=popmin+2*popmax*rand(1,par_num);
    v(i,:)=rands(1,par_num);
    [ty(i),y(i)]=Adpfun(pop(i,:));
end
[best_y, best_index]=min(y);  % 适应度函数的最小值
z_best=pop(best_index,:);      % 群体极值
g_best=pop;                          % 个体极值
y_g_best=y;                           % 个体极值适应度值
y_z_best=best_y;                   % 群体极值适应度值

%% PSO迭代优化
isFlag=0;                                % -1:停止迭代；0: 达到最大迭代次数；1: 达到精度 
stop_error=1e-4;                   % 结束优化的精度
stallnumMax=0;                     % 允许停滞迭代最大次数
stallError = 1e-6;                   % 停滞迭代的精度
for i=1:max_iterm
    % 主循环，更新所有的粒子，一代    
    h_Fig=plotPop(pop,ty,i,y_z_best,z_best,h_Fig);   % 画每代粒子群和最佳粒子
    
    w=w_max-(i-1)*(w_max-w_min)/max_iterm;  % 线性递减惯性权重
    
    for j=1:sizepop                         % 速度更新和粒子更新
        % 内循环：更新每一个粒子
        % -----------PSO公式----------------
        %  v(j,:)=w*(v(j,:)+c1*rand*(g_best(j,:)-pop(j,:))+c2*rand*(z_best-pop(j,:)));
        v(j,:)=w*v(j,:)+c1*rand*(g_best(j,:)-pop(j,:))+c2*rand*(z_best-pop(j,:));
        % -----------PSO公式----------------
        
        % 约束：取值范围
        v(j,v(j,:)>vmax)=vmax;        % 限定速度取值范围
        v(j,v(j,:)<vmin)=vmin;
        pop(j,:)=pop(j,:)+0.5*v(j,:);  % 限定粒子取值范围
        pop(j,pop(j,:)>popmax)=popmax;
        pop(j,pop(j,:)<popmin)=popmin;
        % 粒子变异
        if rand>0.9;kk=ceil(par_num*rand);pop(j,kk)=rand; end   
        
        [ty(j),y(j)]=Adpfun(pop(j,:));  % 新粒子适应度值
        % 内循环结束 
    end
    e=abs(min(y)-y_z_best);          % 适应度函数误差
    for j=1:sizepop                        % 极值更新
        if y(j)<y_g_best(j);g_best(j,:)=pop(j,:);y_g_best(j)=y(j);end  % 更新个体极值
        if y(j)<y_z_best;z_best=pop(j,:);y_z_best=y(j);end              % 更新群体极值
    end
    
    % 判断迭代停止条件
    [e,stallnumMax]     % 根据需要显示迭代优化过程中要观察的变量
    if abs(e)<=1e-6;stallnumMax=stallnumMax+1;else;stallnumMax=0; end         % 记录目标函数连续无变化的次数
    if stallnumMax>=6;      isFlag=-1; break;  end                % 连续6次目标函数无变化，退出
    if y_z_best<=stop_error;  isFlag=1;   break ; end    % 结束：达到精度！ 
    if get(stop,'value')==1; break; end;                 % 手动停止
end
% 更新STOP按钮，显示 CLOSE
set(stop,'style','pushbutton','string','close',...
    'callback','close(gcf)');
%% 显示结果 
str1=sprintf('停止条件=%d;迭代次数=%d,粒子数=%d',isFlag,i,sizepop);
disp(str1);
str1=sprintf('最终估计参数：[%f,%f]',z_best(1),z_best(2));
disp(str1);
str1=sprintf('适应度函数=%f; 相对误差=%f',y_z_best,e);
disp(str1);
% end 
%------------------------------------------------------------------------
%% 待求解函数
function y=myFun(x)
y=(0.5-((sin(sqrt(x(:,1).^2+x(:,2).^2))).^2-0.5)./(1+0.001*(x(:,1).^2+x(:,2).^2)).^2);
% y=16+(x(:,1).^2-8*cos(2*pi*x(:,1)))+(x(:,2).^2-8*cos(2*pi*x(:,2)));
end

%% 适应度函数：最小值
function [y,fval]=Adpfun(x)
y    = myFun(x);
% fval = y;   % 求原函数最小值 
fval = 1/y;   % 求原函数最大值
end

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

%% 画每代的粒子群与最佳粒子
function oldPlot=plotPop(pop,y,i,y_z_best,z_best,oldPlot)
if oldPlot~=0
    delete(oldPlot);
end
subplot(3,1,[1,2]);   % 每代的粒子群
oldPlot=plot3(pop(:,1),pop(:,2),y,z_best(1),z_best(2),y_z_best,'ro','MarkerSize',10,'LineWidth',2);  % 画粒子群
set(oldPlot(1),'MarkerSize',10,'Marker','*', 'LineWidth',2,'LineStyle','none','MarkerEdgeColor','b')
% oldPlot=plot3(pop(:,1),pop(:,2),y,z_best(1),z_best(2),y_z_best,'ro','MarkerSize',10,'Marker','*', 'LineWidth',2,'LineStyle','none');  % 画粒子群
% oldPlot=plot3(pop(:,1),pop(:,2),y,'b*','LineWidth',2,'markersize',10);  % 画粒子群
hold on;drawnow;
subplot 313;          % 每代的最佳粒子
plot(i,z_best(1),'o',i,z_best(2),'*','LineWidth',2,'markersize',5);
hold on;
pause (0.1);
% 将每次迭代的结果保存成图片
% set(gcf,'PaperPositionMode','auto');  % 按当前窗口大小复制图片
% fn=sprintf('%d.png',i);
% h_fig=gcf;
% print(h_fig,'-dpng',fn)
end