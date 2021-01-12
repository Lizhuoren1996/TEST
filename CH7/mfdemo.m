clear ;  clc; clf
x = linspace(-20, 20, 201);
%fis模糊结构  mf隶属函数
mf = [fismf(@trapmf,[-19 -17 -12 -7])     % 梯形
         fismf(@gbellmf,[3 4 -8])                  % 钟形：a-宽 b-两侧的形状 c-中心
         fismf(@trimf,[-9 -1 2])                     % 三角形
         fismf(@gaussmf,[3 5])                     % 高斯：标准差，均值
         fismf(@gauss2mf,[3 10 5 13])         % 组合高斯: 左侧和右侧的参数
         fismf(@smf,[11 17 ]) ]';                    % S型：左零，右1点
y = evalmmf(mf,x);%计算
h=subplot(2,1,1);plot(x,y);
h.YLim=[0 1.2];
str={'trapmf', 'gbellmf', 'trimf', 'gaussmf', 'gauss2mf', 'smf'}; 
text([-15 -8 -1 5 12 18]', 1.08*ones(6,1),str, 'HorizontalAlignment', 'center')
mf = [fismf(@zmf,[-18 -10])                     % Z型: 左1 ，右0点
         fismf(@psigmf,[2 -11 -5 -4])            % 两个S形的乘积：
         fismf(@dsigmf,[5 -3 1 5])                % 两个不同的S形
         fismf(@pimf,[0 7 11 15])                 % pi型
         fismf(@sigmf,[2 15]) ]';                    % S形：a-过渡宽度，c-过渡中心
y = evalmmf(mf,x);
h=subplot(2,1,2);plot(x,y);
h.YLim=[0 1.2];
str={'zmf', 'psigmf', 'dsigmf', 'pimf','sigmf'}; 
text([-18 -8 0 8 18]', 1.08*ones(5,1),str, 'HorizontalAlignment', 'center')

