function exm_ga_01_gray
clc;clear all; clf;
isplot_scm=true; %false; %true;
% f(x) = 11sin(6x) + 7cos(5x), 0 <= x <= 2 * pi 
rng(1)
L = 16; % 编码长度。用二进制时由问题的求解精度决定。L越长，精度越高，但计算量增大。
N = 32; % 种群规模[20,100]。表示每一代种群中所含个体数目。取小时，可提高算法的运算速度，但降低种群的多样性，容易引导起算法早熟。
%  出现假收敛；取大时，又会使得算法效率降低。
M=N*3/2; %M = 48;  % N=32
T = 100;   % 终止进化代数。[100，1000],通常根据种群适应度的稳定情况实时调整T的设置
Pc = 0.8; % 交叉概率，主要搜索算子[0.4-0.99]。较大的Pc容易破坏群体中已形成的优良模式，是搜索的随机性太大；
% 而较小的Pc使发现新个体（特别是优良个体）的速度太慢。较理想的是非一致使用交叉概率。前期使用较大的Pc，后期降低Pc以保留优良个体
Pm = 0.03; % 变异概率。较大的Pm使遗传算法在整个搜索 侬间中大步跳跃，而小的Pm聚焦于特别区域
% 局部搜索。一般在不使用交叉算子时Pm=0.4-1；而在与交叉算子联合使用时Pm=0.0001-0.5
plotFun(100,0,2*pi,T);

%% 随机初值-格雷码染色体
for i = 1 : 1 : N 
    x1(1, i) = rand() * 2 * pi;                                 % 实数编码
    x2(1, i) = uint16(x1(1, i) / (2 * pi) * (2^L-1));    % 16位二进制码
    grayCode(i,:) = num2gray(x2(1, i), L);              % 实数-二进制-格雷码
end
% grayCode
%% 主循环开始
for t = 1 : 1 : T   % 迭代次数
%     t
    y1 = 11 * sin(6 * x1) + 7 * cos(5 * x1); 
    plotgrayCode(grayCode,'r.',isplot_scm);
    for i = 1 : 1 : M / 2                  % 选择复制：种群从32--->48
        [a, b] = min(y1); 
        grayCodeNew(i, :) = grayCode(b, :); 
        grayCodeNew(i + M / 2, :) = grayCode(b, :); 
        y1(1, b) = inf;
%         y1'
    end
    if isplot_scm;plotgrayCode(grayCodeNew,'go',isplot_scm);end

    for i = 1 : 1 : M / 2                 % 交叉
        p = unidrnd(L); 
        if rand() < Pc 
            for j = p : 1 : L 
                temp = grayCodeNew(i, j); 
                grayCodeNew(i, j) = grayCodeNew(M-i + 1, j); 
                grayCodeNew(M - i + 1, j) = temp; 
            end
        end
    end
    if isplot_scm;plotgrayCode(grayCodeNew,'b*',isplot_scm);end

    for i = 1 : 1 : M                     % 变异
        for j = 1 : 1 : L 
            if rand() < Pm 
                grayCodeNew(i, j) = dec2bin(1 -bin2dec(grayCodeNew(i, j))) ; 
            end
        end
    end
    if isplot_scm;plotgrayCode(grayCodeNew,'mp',isplot_scm);end
    
    [x3,y3]=DegrayCode(grayCode);
    for i = 1 : 1 : N                  % 选择：种群从48---->32
        [a, b] = min(y3); 
        x1(1, i) = x3(1, b); 
        grayCode(i, :) = grayCodeNew(b, :); 
        y3(1, b) = inf; 
    end
end
y1 = 11 * sin(6 * x1) + 7 * cos(5 * x1);
[ybest,y_index]=min(y1);
disp('-----最优点-------');
[x1(y_index),ybest]


function plotgrayCode(grayCode,option,isplot_scm)
persistent oldplot;
persistent ii;
persistent item;
if isempty(oldplot)
    oldplot=0;
    ii=1;
    item=1;
end
[x,y]=DegrayCode(grayCode);
subplot 211;
if oldplot==0
    oldplot(1)=plot(x,y,option,'markersize',10,'XDataSource','x','YDataSource','y');
else
    if ii==1    
         refreshdata(oldplot(1),'caller');
        drawnow ;
    else
        oldplot(ii)=plot(x,y,option,'markersize',10);
    end
end
if ii==1
    subplot 212;
    plot(item,min(y),'b*');
    item=item+1;
end

if isplot_scm
    ii=ii+1;
end

if ii==5
    for i=2:ii-1
        delete(oldplot(i));
    end
    ii=1;
end
pause(0.1);

function plotFun(n,LB,UB,T)
% 只画两个变量的函数
% colorbar;  print –dmeta  % print -dbitmap
x= linspace(LB(1),UB(1),n);
y=f(x);
subplot 211;hold on ;
plot(x,y);xlabel('x');ylabel('z');
h2=subplot(2,1,2); hold on;  xlim(h2,[0 T]);
pause(0.1);

function [x,y]=DegrayCode(grayCode)
[n,L]=size(grayCode);
for i = 1 : 1 : n 
    x1(1, i) = gray2num(grayCode(i, :)); 
end
x = double(x1) * 2 * pi / (2^L-1);
y =f(x);  % 11 * sin(6 * x3) + 7 * cos(5 * x3); 

function y=f(x)
y = 11 * sin(6 * x) + 7 * cos(5 * x);
    