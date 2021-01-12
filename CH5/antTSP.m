%% ��Ⱥ�㷨���TSP�����matlab����
clear;clc; rng(0);
figure(1); clf;
set(gcf,'Name','Ant Colony Optimization-Figure of shortest_path','Color','w')
stop = uicontrol('style','toggle','string','stop', ...
    'background','white');   % FIG������stop��ť

% ���е��������
city=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;4196 1004;
    4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;1332 695;3715 1678;
    3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;4263 2931;3429 1908;3507 2367;
    3394 2643;3439 3201;2935 3240;3140 3550;2545 2357;2778 2826;2370 2975];

%% ��ʼ����Ⱥ
m=31;           % ��Ⱥ�����ϵ���������m�ӽ�����ڳ��и���nʱ�����㷨���������ٵĵ����������ҵ����Ž�
Nc_max=50; % �������Ĵ������༴���ϳ����Ĳ�����ÿ�����ϵ�������Ȼ����m��
alpha=0.1;    % �������˶���������������Ϣ������Ϣ�أ�������ѡ��·��ʱ�������Ҫ�̶ȣ�alpha����ʱ���㷨������һ�������󽫳���ͣ������
beta=5;         % ����ʽ����������ѡ��·��ʱ�������Ҫ�̶�
rho=0.5;       % 0<rho<1,��ʾ·������Ϣ�ص�˥��ϵ������ƻӷ�ϵ��������ϵ������1-rho��ʾ��Ϣ�صĳ־���ϵ��
Q=100;         % �����ͷŵ���Ϣ����������Ϣ��ǿ�ȡ��Ա��㷨������Ӱ�첻��

%% ������ʼ��
n=size(city,1);                    % ��ʾTSP����Ĺ�ģ���༴���е�����

% step1����������нڵ�֮��ľ��룬nXn.ֻ����һ��***
D=squareform(pdist(city));% ��ʾ������ȫ��ͼ�ĸ�Ȩ�ڽӾ��󣬼�¼����֮��ľ���

% step2: ������������Expectation��ֻ����һ��***
eta=1./D;                            % ����ʽ���ӣ�Ϊ�ܼ�������,������Ϊ����֮�����ĵ���
eta(find(eta==inf))=1;        % �����ĸΪ��

% step3: ������Ϣ�ؾ���T_Pheromone=nXn��ȫ1����Ȼ�����ü�ʱ��
pheromone=ones(n,n);                 % ��Ϣ�ؾ���,��������κ���������֮��·���ϵĳ�ʼ��Ϣ�ض�Ϊ1
tmp=zeros(n,n);                             % ���ڻ�ͼ��������
tabu_list=zeros(m,n);                     % ���ɱ���¼�����Ѿ��߹��ĳ��У������ڱ���ѭ���в����پ�����Щ���С�
                                                      % ������ѭ�������󣬽��ɱ������������ϵ�ǰ�������Ľ����������������·����·���ĳ���

Nc=0;                                            % ѭ������������
routh_best=zeros(Nc_max,n);       % ����ѭ�������·��
length_best=ones(Nc_max,1);       % ����ѭ�����·���ĳ���
length_average=ones(Nc_max,1); % ����ѭ������·����ƽ������

%%
tic;                                                   % ���ü�ʱ��
% step4: ����������Loop_Max
while Nc<Nc_max   % ��ѭ��
    % step5: ��mֻ��������ŵ�x�����нڵ��ϣ�x�����нڵ��������
    rand_position=randperm(m);
    tabu_list(:,1)=(rand_position(1:m))';
    % �����Ϸ��ڳ�����֮��Ľ��ɱ���i�б�ʾ��iֻ���ϣ���i�е�һ��Ԫ�ر�ʾ��iֻ�������ڵĳ�ʼ����
    
    % mֻ���ϰ����ʺ���ѡ����һ�����У��ڱ���ѭ������ɸ��Ե�����
    for j=2:n      % ��ѭ����ÿֻ���Ϸ��ʵĵ�n������
        for i=1:m % ��ѭ����һֻ���ϣ�����һ������
            % step6:��ÿֻ�����ҵ���û�з��ʹ��Ľڵ��б�No_visited,
            % �����չ�ʽ1����ӵ�ǰ�ڵ�ת�Ƶ�δ���ʵ����нڵ��ת�Ƹ����б�P
            city_visited=tabu_list(i,1:(j-1));       % �ѷ��ʵĳ���
            city_remained=zeros(1,(n-j+1));    % �����ʵĳ���
            probability=city_remained;            % �����ʳ��е�ѡ����ʷֲ�
            cr=1;
            
            % step6_1
            for k=1:n  % forѭ������������ʵĳ��С���5�����У��ѷ��ʳ���
                % city_visited=[2 4],�򾭹���forѭ����city_remanied=[1 3 5];
                if length(find(city_visited==k))==0
                    city_remained(cr)=k;
                    cr=cr+1;
                end
            end
            % ״̬ת�ƹ���****************************************
            % step6_2������ӵ�ǰ�ڵ�ת�Ƶ�δ���ʵ����нڵ��ת�Ƹ����б�P
            for k=1:length(city_remained)   % ��ѡ���еĸ��ʷֲ�
                probability(k)=(pheromone(city_visited(end),city_remained(k)))^alpha*(eta(city_visited(end),city_remained(k)))^beta;
            end
            % step7 :ʹ�����̶ķ���ѡ��ĳ���ڵ�j, ����j�ڵ���뵽�ѷ��ʽڵ��е�visited�У�ֱ�����нڵ㱻ȫ������
            q0=0.5;
            if rand>q0  % �������ʺ���ѡȡ
                position=find(probability==max(probability));
                to_visit=city_remained(position);
                
            else            % ���ۻ���ѡȡ
                probability=probability/sum(probability);
                pcum=cumsum(probability);  % �ۻ��ͣ�ȱʡ����
                select=find(pcum>=rand);     % ���̶�
                to_visit=city_remained(select(1));
            end
            tabu_list(i,j)=to_visit;                  % ���ɱ�
            %**************************************************************
        end
    end
    if Nc>0
        tabu_list(1,:)=routh_best(Nc,:);       % ����һ��������·�������Ž⣩������������֤��һ���е�����Ӧ�������Ϣ���ᶪʧ
    end
    
    % ��¼����ѭ�������·��
    total_length=zeros(m,1);   % mֻ�����ڱ���ѭ���зֱ����߹���·������
    for i=1:m
        r=tabu_list(i,:);              % ȡ����iֻ�����ڱ���ѭ�������ߵ�·��
        for j=1:(n-1)
            total_length(i)=total_length(i)+D(r(j),r(j+1));    % ��iֻ���ϱ���ѭ���д������е��յ�������߹���·������
        end
        total_length(i)=total_length(i)+D(r(1),r(n));          % ���յõ���iֻ�����ڱ���ѭ�������߹���·������
    end
    
    length_best(Nc+1)=min(total_length);                     % ��mֻ�����ڱ���ѭ��������·�����ȵ���Сֵ��Ϊ����ѭ�������·���ĳ���
    position=find(total_length==length_best(Nc+1));  % �ҵ����·����λ�ã������·���ǵڼ�ֻ���ϻ��ļ�ֻ�����߳�����
    routh_best(Nc+1,:)=tabu_list(position(1),:);             % �ѵ�һ���߳����·���������ڱ���ѭ�������ߵ�·����Ϊ����ѭ���е�����·��
    length_average(Nc+1)=mean(total_length);           % ���㱾��ѭ����mֻ��������·����ƽ������
    Nc=Nc+1;
    
    % step10: ���չ�ʽ��3��������Ϣ�ؾ���T_Pheromone�ĸ���
    
    % step9: ���չ�ʽ��4��-��5�����㦤��ij(t)������tΪ���ε�ѭ������
    % ������Ϣ��
    delta_pheromone=zeros(n,n);
    for i=1:m
        for j=1:(n-1)
            % total_length(i)Ϊ��iֻ�����ڱ���ѭ�������߹���·�����ȣ�����ϵͳ����������ϵͳ������ϵͳ�ĵط���
            %             tabu_list(i,j),tabu_list(i,j+1),Q/total_length(i)
            delta_pheromone(tabu_list(i,j),tabu_list(i,j+1))=delta_pheromone(tabu_list(i,j),tabu_list(i,j+1))+Q/total_length(i);
        end
        delta_pheromone(tabu_list(i,n),tabu_list(i,1))=delta_pheromone(tabu_list(i,n),tabu_list(i,1))+Q/total_length(i);
        % ���˰ѵ�iֻ�����ڱ���ѭ����������·�����ͷŵ���Ϣ���Ѿ��ۼ���ȥ
        
    end % ���˰�mֻ�����ڱ���ѭ����������·�����ͷŵ���Ϣ���Ѿ��ۼ���ȥ
    pheromone=(1-rho).*pheromone+delta_pheromone; % ����ѭ��������·���ϵ���Ϣ��
    %----------------------------
    %% �������·�����������ϵ�·��
    if Nc>1
        figure(1);subplot 121;
        scatter(city(:,1),city(:,2),50,'filled');  % ɢ��ͼ
        hold on;
        for iii=1:length(tabu_list(:,1))
            path=tabu_list(iii,:);
            if iii==position
                plot([city(path(1),1),city(path(m),1)],[city(path(1),2),city(path(m),2)],'r-','linewidth',3)
                plot(city(path,1),city(path,2),'g-','linewidth',3);
                text(city(path,1)+10,city(path,2)+100,num2cell(1:n));
                title(strcat('Nc=',num2str(Nc-1),',��Ӣ����',num2str(position),'��·������=',num2str(length_best(Nc-1))));
            else
                plot(city(path,1),city(path,2));
            end
            %     tmp=tmp+delta_pheromone;
            %     figure(1);imshow(tmp);
            %     %----------------------------
        end
        hold off;
    end
    % ����Ϣ�ؾ���
    subplot 122;
    imshow(pheromone/0.2);
    % ���ɱ����㣬׼����һ��ѭ������������һ��ѭ�����ֿ������ɵؽ���ѡ��
    tabu_list=zeros(m,n);
    pause(0.1);
    if get(stop,'value')==1; break; end;
    % step11: ת������4
end
set(stop,'style','pushbutton','string','close',...
    'callback','close(gcf)');

% step12: ֹͣ��ʱ��������¼����ʱ�䵽Time��
TSPtime=toc
% step13: ��¼�㷨�ҵ�������·���ͳ���

% ������������ͼ��
position=find(length_best==min(length_best));
shortest_path=routh_best(position(1),:);
shortest_length=length_best(position(1));

%% �������·��
pause(2);
figure(1);subplot 121;
scatter(city(:,1),city(:,2),50,'filled');  hold on
plot([city(shortest_path(1),1),city(shortest_path(m),1)],[city(shortest_path(1),2),city(shortest_path(m),2)],'r-','linewidth',3)
set(gca,'Color','g');
plot(city(shortest_path,1),city(shortest_path,2),'linewidth',3);hold off;
text(city(shortest_path,1)+10,city(shortest_path,2)+100,num2cell(1:m));
title(strcat('���·�������ڵ�',num2str(position(1)),'����·������=',num2str(length_best(Nc-1))));

figure(2);plot(length_average,'k');hold on;
plot(length_best,'r-');hold off;
legend('L-avreage','L-best');
