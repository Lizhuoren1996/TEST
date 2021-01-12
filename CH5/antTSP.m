%% 蚁群算法求解TSP问题的matlab程序
clear;clc; rng(0);
figure(1); clf;
set(gcf,'Name','Ant Colony Optimization-Figure of shortest_path','Color','w')
stop = uicontrol('style','toggle','string','stop', ...
    'background','white');   % FIG上设置stop按钮

% 城市的坐标矩阵
city=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;4196 1004;
    4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;1332 695;3715 1678;
    3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2367;
    3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;2370 2975];

%% 初始化蚁群
m=31;           % 蚁群中蚂蚁的数量，当m接近或等于城市个数n时，本算法可以在最少的迭代次数内找到最优解
Nc_max=50; % 最大迭代的次数，亦即蚂蚁出动的拨数（每拨蚂蚁的数量当然都是m）
alpha=0.1;    % 蚂蚁在运动过程中所积累信息（即信息素）在蚂蚁选择路径时的相对重要程度，alpha过大时，算法迭代到一定代数后将出现停滞现象
beta=5;         % 启发式因子在蚂蚁选择路径时的相对重要程度
rho=0.5;       % 0<rho<1,表示路径上信息素的衰减系数（亦称挥发系数、蒸发系数），1-rho表示信息素的持久性系数
Q=100;         % 蚂蚁释放的信息素量，，信息素强度。对本算法的性能影响不大

%% 变量初始化
n=size(city,1);                    % 表示TSP问题的规模，亦即城市的数量

% step1：计算各城市节点之间的距离，nXn.只计算一次***
D=squareform(pdist(city));% 表示城市完全地图的赋权邻接矩阵，记录城市之间的距离

% step2: 计算期望矩阵Expectation，只计算一次***
eta=1./D;                            % 启发式因子，为能见度因数,这里设为城市之间距离的倒数
eta(find(eta==inf))=1;        % 避免分母为零

% step3: 设置信息素矩阵T_Pheromone=nXn的全1矩阵，然后设置计时器
pheromone=ones(n,n);                 % 信息素矩阵,这里假设任何两个城市之间路径上的初始信息素都为1
tmp=zeros(n,n);                             % 用于画图？？？？
tabu_list=zeros(m,n);                     % 禁忌表，记录蚂蚁已经走过的城市，蚂蚁在本次循环中不能再经过这些城市。
                                                      % 当本次循环结束后，禁忌表被用来计算蚂蚁当前所建立的解决方案，即经过的路径和路径的长度

Nc=0;                                            % 循环次数计数器
routh_best=zeros(Nc_max,n);       % 各次循环的最短路径
length_best=ones(Nc_max,1);       % 各次循环最短路径的长度
length_average=ones(Nc_max,1); % 各次循环所有路径的平均长度

%%
tic;                                                   % 设置计时器
% step4: 检测迭代次数Loop_Max
while Nc<Nc_max   % 外循环
    % step5: 将m只蚂蚁随机放到x个城市节点上，x个城市节点随机产生
    rand_position=randperm(m);
    tabu_list(:,1)=(rand_position(1:m))';
    % 将蚂蚁放在城市上之后的禁忌表，第i行表示第i只蚂蚁，第i行第一列元素表示第i只蚂蚁所在的初始城市
    
    % m只蚂蚁按概率函数选择下一座城市，在本次循环中完成各自的周游
    for j=2:n      % 中循环，每只蚂蚁访问的第n个城市
        for i=1:m % 内循环，一只蚂蚁，访问一个城市
            % step6:对每只蚂蚁找到其没有访问过的节点列表No_visited,
            % 并按照公式1计算从当前节点转移到未访问的所有节点的转移概率列表P
            city_visited=tabu_list(i,1:(j-1));       % 已访问的城市
            city_remained=zeros(1,(n-j+1));    % 待访问的城市
            probability=city_remained;            % 待访问城市的选择概率分布
            cr=1;
            
            % step6_1
            for k=1:n  % for循环用于求待访问的城市。如5个城市，已访问城市
                % city_visited=[2 4],则经过此for循环后city_remanied=[1 3 5];
                if length(find(city_visited==k))==0
                    city_remained(cr)=k;
                    cr=cr+1;
                end
            end
            % 状态转移规则****************************************
            % step6_2：计算从当前节点转移到未访问的所有节点的转移概率列表P
            for k=1:length(city_remained)   % 待选城市的概率分布
                probability(k)=(pheromone(city_visited(end),city_remained(k)))^alpha*(eta(city_visited(end),city_remained(k)))^beta;
            end
            % step7 :使用轮盘赌方法选中某个节点j, 并将j节点加入到已访问节点列点visited中，直到所有节点被全部访问
            q0=0.5;
            if rand>q0  % 按最大概率函数选取
                position=find(probability==max(probability));
                to_visit=city_remained(position);
                
            else            % 按累积和选取
                probability=probability/sum(probability);
                pcum=cumsum(probability);  % 累积和，缺省按列
                select=find(pcum>=rand);     % 轮盘赌
                to_visit=city_remained(select(1));
            end
            tabu_list(i,j)=to_visit;                  % 禁忌表
            %**************************************************************
        end
    end
    if Nc>0
        tabu_list(1,:)=routh_best(Nc,:);       % 将上一代的最优路径（最优解）保留下来，保证上一代中的最适应个体的信息不会丢失
    end
    
    % 记录本次循环的最佳路线
    total_length=zeros(m,1);   % m只蚂蚁在本次循环中分别所走过的路径长度
    for i=1:m
        r=tabu_list(i,:);              % 取出第i只蚂蚁在本次循环中所走的路径
        for j=1:(n-1)
            total_length(i)=total_length(i)+D(r(j),r(j+1));    % 第i只蚂蚁本次循环中从起点城市到终点城市所走过的路径长度
        end
        total_length(i)=total_length(i)+D(r(1),r(n));          % 最终得到第i只蚂蚁在本次循环中所走过的路径长度
    end
    
    length_best(Nc+1)=min(total_length);                     % 把m只蚂蚁在本次循环中所走路径长度的最小值作为本次循环中最短路径的长度
    position=find(total_length==length_best(Nc+1));  % 找到最短路径的位置，即最短路径是第几只蚂蚁或哪几只蚂蚁走出来的
    routh_best(Nc+1,:)=tabu_list(position(1),:);             % 把第一个走出最短路径的蚂蚁在本次循环中所走的路径作为本次循环中的最优路径
    length_average(Nc+1)=mean(total_length);           % 计算本次循环中m只蚂蚁所走路径的平均长度
    Nc=Nc+1;
    
    % step10: 按照公式（3）进行信息素矩阵T_Pheromone的更新
    
    % step9: 按照公式（4）-（5）计算Δτij(t)，其中t为本次的循环次数
    % 更新信息素
    delta_pheromone=zeros(n,n);
    for i=1:m
        for j=1:(n-1)
            % total_length(i)为第i只蚂蚁在本次循环中所走过的路径长度（蚁周系统区别于蚁密系统和蚁量系统的地方）
            %             tabu_list(i,j),tabu_list(i,j+1),Q/total_length(i)
            delta_pheromone(tabu_list(i,j),tabu_list(i,j+1))=delta_pheromone(tabu_list(i,j),tabu_list(i,j+1))+Q/total_length(i);
        end
        delta_pheromone(tabu_list(i,n),tabu_list(i,1))=delta_pheromone(tabu_list(i,n),tabu_list(i,1))+Q/total_length(i);
        % 至此把第i只蚂蚁在本次循环中在所有路径上释放的信息素已经累加上去
        
    end % 至此把m只蚂蚁在本次循环中在所有路径上释放的信息素已经累加上去
    pheromone=(1-rho).*pheromone+delta_pheromone; % 本次循环后所有路径上的信息素
    %----------------------------
    %% 绘制最短路径及所有蚂蚁的路径
    if Nc>1
        figure(1);subplot 121;
        scatter(city(:,1),city(:,2),50,'filled');  % 散点图
        hold on;
        for iii=1:length(tabu_list(:,1))
            path=tabu_list(iii,:);
            if iii==position
                plot([city(path(1),1),city(path(m),1)],[city(path(1),2),city(path(m),2)],'r-','linewidth',3)
                plot(city(path,1),city(path,2),'g-','linewidth',3);
                text(city(path,1)+10,city(path,2)+100,num2cell(1:n));
                title(strcat('Nc=',num2str(Nc-1),',精英蚂蚁',num2str(position),'，路径长度=',num2str(length_best(Nc-1))));
            else
                plot(city(path,1),city(path,2));
            end
            %     tmp=tmp+delta_pheromone;
            %     figure(1);imshow(tmp);
            %     %----------------------------
        end
        hold off;
    end
    % 画信息素矩阵
    subplot 122;
    imshow(pheromone/0.2);
    % 禁忌表清零，准备下一次循环，蚂蚁在下一次循环中又可以自由地进行选择
    tabu_list=zeros(m,n);
    pause(0.1);
    if get(stop,'value')==1; break; end;
    % step11: 转到步骤4
end
set(stop,'style','pushbutton','string','close',...
    'callback','close(gcf)');

% step12: 停止计时器，并记录运行时间到Time中
TSPtime=toc
% step13: 记录算法找到的最优路径和长度

% 输出结果，绘制图形
position=find(length_best==min(length_best));
shortest_path=routh_best(position(1),:);
shortest_length=length_best(position(1));

%% 绘制最短路径
pause(2);
figure(1);subplot 121;
scatter(city(:,1),city(:,2),50,'filled');  hold on
plot([city(shortest_path(1),1),city(shortest_path(m),1)],[city(shortest_path(1),2),city(shortest_path(m),2)],'r-','linewidth',3)
set(gca,'Color','g');
plot(city(shortest_path,1),city(shortest_path,2),'linewidth',3);hold off;
text(city(shortest_path,1)+10,city(shortest_path,2)+100,num2cell(1:m));
title(strcat('最短路径出现在第',num2str(position(1)),'代，路径长度=',num2str(length_best(Nc-1))));

figure(2);plot(length_average,'k');hold on;
plot(length_best,'r-');hold off;
legend('L-avreage','L-best');
