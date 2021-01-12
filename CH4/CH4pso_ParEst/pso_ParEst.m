function [storage,y_g_best]=pso_ParEst
%% 粒子群算法求极值
% 考虑如下二阶时变系统的辨识问题：
% y(t)-1.5*y(t-1)+0.7*y(t-2)=b1(t)*u(t-1)+0.5*u(t-2)+vk
% 式中b1(t)表示时变得参数，分以下两种情况
% 参数发生突变 b1(t)=1.0*(1<=t&&t<40)+0.6*(40<=t&&t<80)+1.0*(80<=t&&t<100)
% 参数发生渐变 b1(t)=1.0*((1<=t&&t<40)||(100<=t&&t<120))+(1.0-(t-40)*0.01)*(40<=t&&t<80)+(0.6+(t-80)*0.02)*(80<=t&&t<100)
% (该参数辨识问题使用粒子群算法时每个粒子代表的意义是4个参数的值
% 设为z()=[z(1),z(2),z(3),z(4)])，
% 真实值为[-1.5,-0.7,b1(t),-0.5]，
% 正负号和具体程序有关

clear;close all;clc
global itermMax popSize popMax popMin vMax vMin c1 c2 wMax wMin par_num

Weight_flag=1;                               % 1-标准PSO  2-ACW_PSO  3-DCW_PSO  4-KPSO
Noise_flag=0;                                  % 0-无噪声   1-有噪声
Np_flag=1;                                      % 时变参数 1-渐变     2-突变

pop=zeros(popSize,par_num);
y=zeros(1,popSize);
u=idinput([63 1 5],'prbs');

%% 时变参数变化方式选择
switch Np_flag
    case 1                                     % 1-渐变
        Np=120;
        vk=(Noise_flag==0)*0+(Noise_flag==1)*wgn(1,Np,0.01,'linear');      % 是否加噪声
        yest=zeros(1,Np); yreal=zeros(1,Np); b=ones(1,Np);
        for k=3:Np
            if 40<=k && k<80;  b(k)=1-(k-40)*0.01;
            elseif 80<=k&&k<100; b(k)=0.6+(k-80)*0.02;
            else;  b(k)=1;  end
            yreal(k)=1.5*yreal(k-1)-0.7*yreal(k-2)+b(k)*u(k-1)+0.5*u(k-2)+vk(k);
        end
    case 2                                     % 2-突变
        Np=100;
        vk=(Noise_flag==0)*0+(Noise_flag==1)*wgn(1,Np,0.01,'linear');      % 是否加噪声
        yest=zeros(1,Np);  yreal=zeros(1,Np); b=ones(1,Np);
        for k=3:Np
            if 40<=k && k<80;   b(k)=0.6;
            else; b(k)=1;    end
            yreal(k)=1.5*yreal(k-1)-0.7*yreal(k-2)+b(k)*u(k-1)+0.5*u(k-2)+vk(k);
        end
end
%% 设置PSO参数
setPOSPar;
%% 画系统输入输出
subplot 211;plot(yreal);
subplot 212;stairs(u(1:Np),'-o');    % stem(u(1:Np));
axis([1 Np -1.5 1.5]);

%% 画模型参数真值
figure(1)
subplot 313
plot(1:Np,-1.5,'r-',1:Np,-0.7,'b-',1:Np,b,'m-',1:Np,-0.5,'k-','linewidth',2);
hold on;
%% 第一个时间窗内最佳粒子初值和函数值 时间窗长度为10
x=zeros(1,par_num);
for k=3:11  % 要大于适应度函数中的时间窗长度，k=1,2时参数均为0，与差分方程有关
    x=popMin+2*popMax*rand(1,par_num);
    yest(k)=sum(x.*[-yest(k-1),yest(k-2),u(k-1),-u(k-2)]);
end
%% 辨识主循环开始==================
for k=12:10:Np    % 从第二个时间窗开始，增量4是为了加快显示结果
    % 画模型参数真值
    h1=subplot(3,1,1);  cla(h1);
    plot(1:itermMax,-1.5,'r--',1:itermMax,-0.7,'b--',1:itermMax,b(k),'m--',1:itermMax,-0.5,'k--');
    hold on;
    h2=subplot(3,1,2);cla(h2); hold on;   % 刷新子图
    
    % 粒子初始化
    for i=1:popSize                            % 粒子初始化
        pop(i,:)=popMin+2*popMax*rand(1,par_num);
        v(i,:)=vMin+2*vMax*rand(1,par_num);
        y(i)=AdpFun(pop(i,:),k,yest,yreal,u);
    end
    [best_y, best_index]=min(y);                % 适应度函数的最小值
    g_best=pop(best_index,:);                   % 群体极值
    p_best=pop;                                       % 个体极值
    y_p_best=y;                                        % 个体极值适应度值
    y_g_best=best_y;                                % 群体极值适应度值
    
    
    % PSO惯性因子选择
    switch Weight_flag
        case 1                                            % 标准PSO
            w=0.729;                                   % 惯性权重
        case 2                                            % ACW_PSO
            for i=1:itermMax
                w=wMax-(i-1)*(wMax-wMin)/itermMax; % 线性递减惯性权重
            end
        case 3                                             % DCW_PSO
            for i=1:itermMax
                e=best_y/y_g_best;                 % DCW_PSO粒子进化度
                a=popSize*best_y/sum(y);      % DCW_PSO粒子聚合度
                w0=0.9;                                   % w0为w的初始值
                w=w0-0.5*e+0.1*a;                  % 惯性因子w
                y_g_best=best_y;                     % 把当前全局最优值赋给y_g_best
            end
        case 4                                              % KPSO
            K=0.729;                                      % 压缩因子
    end
    % 学习因子选择
    if Weight_flag==4
        c1=2.05;c2=2.05;                             % 学习因子
    else
        c1 = 2; c2 = 2;
    end
    
    % PSO迭代优化-主循环开始------------------------
    for i=1:itermMax
        for j=1:popSize                                  % 速度更新
            if Weight_flag==4                          % KPSO的速度更新公式
                v(j,:)=K*(v(j,:)+c1*rand*(p_best(j,:)-pop(j,:))+c2*rand*(g_best-pop(j,:)));
            else
                v(j,:)=w*v(j,:)+c1*rand*(p_best(j,:)-pop(j,:))+c2*rand*(g_best-pop(j,:));
            end
            v(j,v(j,:)>vMax)=vMax;                     % 速度因子限幅
            v(j,v(j,:)<vMin)=vMin;
            
            pop(j,:)=pop(j,:)+v(j,:);                     % 粒子更新
            p(j,pop(j,:)>popMax)=popMax;       % 粒子限幅
            p(j,pop(j,:)<popMin)=popMin;
            % 2、变异
            if rand>0.9                                      % 粒子变异
                kk=ceil(2*rand);     %%%%%%%%%%%%%%%%%%%%%%%  par_num*
                pop(j,kk)=rand;
            end
            y(j)=AdpFun(pop(j,:),k,yest,yreal,u); % 新粒子适应度值
        end
        % 3、更新极值
        for j=1:popSize                                   % 极值更新，最优值为最小值
            if y(j)<y_p_best(j)                            % 更新个体最优
                p_best(j,:)=pop(j,:);y_p_best(j)=y(j);
            end
            if y(j)<y_g_best                               % 更新全局最优
                g_best=pop(j,:);y_g_best=y(j);
            end
        end
        % 4、终止条件
        if abs(y_g_best)<=0.01                      % 符合精度即跳出，加快效率
            break;
        end
        
        % 画每代的粒子群与最佳粒子，用更新粒子坐标的方式
        subplot 311
        plot(i,g_best(1),'ro',i,g_best(2),'bo',i,g_best(3),'mo',i,g_best(4),'ko');
        
        subplot 312
        plot(i,y_g_best,'r*')
        drawnow;
    end    % PSO迭代优化-主循环开始----------------------------
    
    storage(k,:)=g_best;
    yest(k)=sum(g_best.*[-yest(k-1),yest(k-2),u(k-1),-u(k-2)]);
    subplot 313
    plot(k,g_best(1),'r*',k,g_best(2),'b*',k,g_best(3),'m*',k,g_best(4),'k*');
    hold on
end  % 模型辨识主循环结束=============

%%
end

%% ----------子函数------------
%% 粒子群优化参数设置
function setPOSPar
global itermMax popSize popMax popMin vMax vMin wMax wMin par_num stopError stallError stallnumMax stallnum
par_num=4;                        % 待辨识的参数个数
itermMax = 40;                   % 最大迭代次数
popSize = 30;                     % 粒子数
popMax = 2;                      % 粒子的最大值
popMin = -2;                     % 粒子的最小值
vMax = 1;                           % 速度的最大值
vMin = -1;                          % 速度的最小值
wMax = 0.9;                       % 惯性权重的初始值
wMin = 0.4;                        % 惯性权重的终止值
stopError = 1e-6;                % 结束优化的精度
stallError = 1e-6;                % 停滞迭代的精度
stallnumMax = 20;             % 最大停滞代数
stallnum = 0;                      % 停滞代数
end

%% 适应度函数
function J=AdpFun(x,k,yest,yreal,u)
J=0;
L=10;          % 要与主函数时间窗长度一致
beta=zeros(1,L);
for i=1:L
    beta(i)=0.95^(L-i);             % 遗忘因子
end
for i=1:L
    t=k-L+i;
    if (t)<=2
        yest(t)=0;
    else
        yest(t)=sum(x.*[-yreal(t-1),yreal(t-2),u(t-1),-u(t-2)]);
    end
    J=J+beta(i)*(yreal(t)-yest(t))^2;
end
end