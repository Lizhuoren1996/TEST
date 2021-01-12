function [storage,y_g_best]=pso_ParEst
%% ����Ⱥ�㷨��ֵ
% �������¶���ʱ��ϵͳ�ı�ʶ���⣺
% y(t)-1.5*y(t-1)+0.7*y(t-2)=b1(t)*u(t-1)+0.5*u(t-2)+vk
% ʽ��b1(t)��ʾʱ��ò������������������
% ��������ͻ�� b1(t)=1.0*(1<=t&&t<40)+0.6*(40<=t&&t<80)+1.0*(80<=t&&t<100)
% ������������ b1(t)=1.0*((1<=t&&t<40)||(100<=t&&t<120))+(1.0-(t-40)*0.01)*(40<=t&&t<80)+(0.6+(t-80)*0.02)*(80<=t&&t<100)
% (�ò�����ʶ����ʹ������Ⱥ�㷨ʱÿ�����Ӵ����������4��������ֵ
% ��Ϊz()=[z(1),z(2),z(3),z(4)])��
% ��ʵֵΪ[-1.5,-0.7,b1(t),-0.5]��
% �����ź;�������й�

clear;close all;clc
global itermMax popSize popMax popMin vMax vMin c1 c2 wMax wMin par_num

Weight_flag=1;                               % 1-��׼PSO  2-ACW_PSO  3-DCW_PSO  4-KPSO
Noise_flag=0;                                  % 0-������   1-������
Np_flag=1;                                      % ʱ����� 1-����     2-ͻ��

pop=zeros(popSize,par_num);
y=zeros(1,popSize);
u=idinput([63 1 5],'prbs');

%% ʱ������仯��ʽѡ��
switch Np_flag
    case 1                                     % 1-����
        Np=120;
        vk=(Noise_flag==0)*0+(Noise_flag==1)*wgn(1,Np,0.01,'linear');      % �Ƿ������
        yest=zeros(1,Np); yreal=zeros(1,Np); b=ones(1,Np);
        for k=3:Np
            if 40<=k && k<80;  b(k)=1-(k-40)*0.01;
            elseif 80<=k&&k<100; b(k)=0.6+(k-80)*0.02;
            else;  b(k)=1;  end
            yreal(k)=1.5*yreal(k-1)-0.7*yreal(k-2)+b(k)*u(k-1)+0.5*u(k-2)+vk(k);
        end
    case 2                                     % 2-ͻ��
        Np=100;
        vk=(Noise_flag==0)*0+(Noise_flag==1)*wgn(1,Np,0.01,'linear');      % �Ƿ������
        yest=zeros(1,Np);  yreal=zeros(1,Np); b=ones(1,Np);
        for k=3:Np
            if 40<=k && k<80;   b(k)=0.6;
            else; b(k)=1;    end
            yreal(k)=1.5*yreal(k-1)-0.7*yreal(k-2)+b(k)*u(k-1)+0.5*u(k-2)+vk(k);
        end
end
%% ����PSO����
setPOSPar;
%% ��ϵͳ�������
subplot 211;plot(yreal);
subplot 212;stairs(u(1:Np),'-o');    % stem(u(1:Np));
axis([1 Np -1.5 1.5]);

%% ��ģ�Ͳ�����ֵ
figure(1)
subplot 313
plot(1:Np,-1.5,'r-',1:Np,-0.7,'b-',1:Np,b,'m-',1:Np,-0.5,'k-','linewidth',2);
hold on;
%% ��һ��ʱ�䴰��������ӳ�ֵ�ͺ���ֵ ʱ�䴰����Ϊ10
x=zeros(1,par_num);
for k=3:11  % Ҫ������Ӧ�Ⱥ����е�ʱ�䴰���ȣ�k=1,2ʱ������Ϊ0�����ַ����й�
    x=popMin+2*popMax*rand(1,par_num);
    yest(k)=sum(x.*[-yest(k-1),yest(k-2),u(k-1),-u(k-2)]);
end
%% ��ʶ��ѭ����ʼ==================
for k=12:10:Np    % �ӵڶ���ʱ�䴰��ʼ������4��Ϊ�˼ӿ���ʾ���
    % ��ģ�Ͳ�����ֵ
    h1=subplot(3,1,1);  cla(h1);
    plot(1:itermMax,-1.5,'r--',1:itermMax,-0.7,'b--',1:itermMax,b(k),'m--',1:itermMax,-0.5,'k--');
    hold on;
    h2=subplot(3,1,2);cla(h2); hold on;   % ˢ����ͼ
    
    % ���ӳ�ʼ��
    for i=1:popSize                            % ���ӳ�ʼ��
        pop(i,:)=popMin+2*popMax*rand(1,par_num);
        v(i,:)=vMin+2*vMax*rand(1,par_num);
        y(i)=AdpFun(pop(i,:),k,yest,yreal,u);
    end
    [best_y, best_index]=min(y);                % ��Ӧ�Ⱥ�������Сֵ
    g_best=pop(best_index,:);                   % Ⱥ�弫ֵ
    p_best=pop;                                       % ���弫ֵ
    y_p_best=y;                                        % ���弫ֵ��Ӧ��ֵ
    y_g_best=best_y;                                % Ⱥ�弫ֵ��Ӧ��ֵ
    
    
    % PSO��������ѡ��
    switch Weight_flag
        case 1                                            % ��׼PSO
            w=0.729;                                   % ����Ȩ��
        case 2                                            % ACW_PSO
            for i=1:itermMax
                w=wMax-(i-1)*(wMax-wMin)/itermMax; % ���Եݼ�����Ȩ��
            end
        case 3                                             % DCW_PSO
            for i=1:itermMax
                e=best_y/y_g_best;                 % DCW_PSO���ӽ�����
                a=popSize*best_y/sum(y);      % DCW_PSO���Ӿۺ϶�
                w0=0.9;                                   % w0Ϊw�ĳ�ʼֵ
                w=w0-0.5*e+0.1*a;                  % ��������w
                y_g_best=best_y;                     % �ѵ�ǰȫ������ֵ����y_g_best
            end
        case 4                                              % KPSO
            K=0.729;                                      % ѹ������
    end
    % ѧϰ����ѡ��
    if Weight_flag==4
        c1=2.05;c2=2.05;                             % ѧϰ����
    else
        c1 = 2; c2 = 2;
    end
    
    % PSO�����Ż�-��ѭ����ʼ------------------------
    for i=1:itermMax
        for j=1:popSize                                  % �ٶȸ���
            if Weight_flag==4                          % KPSO���ٶȸ��¹�ʽ
                v(j,:)=K*(v(j,:)+c1*rand*(p_best(j,:)-pop(j,:))+c2*rand*(g_best-pop(j,:)));
            else
                v(j,:)=w*v(j,:)+c1*rand*(p_best(j,:)-pop(j,:))+c2*rand*(g_best-pop(j,:));
            end
            v(j,v(j,:)>vMax)=vMax;                     % �ٶ������޷�
            v(j,v(j,:)<vMin)=vMin;
            
            pop(j,:)=pop(j,:)+v(j,:);                     % ���Ӹ���
            p(j,pop(j,:)>popMax)=popMax;       % �����޷�
            p(j,pop(j,:)<popMin)=popMin;
            % 2������
            if rand>0.9                                      % ���ӱ���
                kk=ceil(2*rand);     %%%%%%%%%%%%%%%%%%%%%%%  par_num*
                pop(j,kk)=rand;
            end
            y(j)=AdpFun(pop(j,:),k,yest,yreal,u); % ��������Ӧ��ֵ
        end
        % 3�����¼�ֵ
        for j=1:popSize                                   % ��ֵ���£�����ֵΪ��Сֵ
            if y(j)<y_p_best(j)                            % ���¸�������
                p_best(j,:)=pop(j,:);y_p_best(j)=y(j);
            end
            if y(j)<y_g_best                               % ����ȫ������
                g_best=pop(j,:);y_g_best=y(j);
            end
        end
        % 4����ֹ����
        if abs(y_g_best)<=0.01                      % ���Ͼ��ȼ��������ӿ�Ч��
            break;
        end
        
        % ��ÿ��������Ⱥ��������ӣ��ø�����������ķ�ʽ
        subplot 311
        plot(i,g_best(1),'ro',i,g_best(2),'bo',i,g_best(3),'mo',i,g_best(4),'ko');
        
        subplot 312
        plot(i,y_g_best,'r*')
        drawnow;
    end    % PSO�����Ż�-��ѭ����ʼ----------------------------
    
    storage(k,:)=g_best;
    yest(k)=sum(g_best.*[-yest(k-1),yest(k-2),u(k-1),-u(k-2)]);
    subplot 313
    plot(k,g_best(1),'r*',k,g_best(2),'b*',k,g_best(3),'m*',k,g_best(4),'k*');
    hold on
end  % ģ�ͱ�ʶ��ѭ������=============

%%
end

%% ----------�Ӻ���------------
%% ����Ⱥ�Ż���������
function setPOSPar
global itermMax popSize popMax popMin vMax vMin wMax wMin par_num stopError stallError stallnumMax stallnum
par_num=4;                        % ����ʶ�Ĳ�������
itermMax = 40;                   % ����������
popSize = 30;                     % ������
popMax = 2;                      % ���ӵ����ֵ
popMin = -2;                     % ���ӵ���Сֵ
vMax = 1;                           % �ٶȵ����ֵ
vMin = -1;                          % �ٶȵ���Сֵ
wMax = 0.9;                       % ����Ȩ�صĳ�ʼֵ
wMin = 0.4;                        % ����Ȩ�ص���ֵֹ
stopError = 1e-6;                % �����Ż��ľ���
stallError = 1e-6;                % ͣ�͵����ľ���
stallnumMax = 20;             % ���ͣ�ʹ���
stallnum = 0;                      % ͣ�ʹ���
end

%% ��Ӧ�Ⱥ���
function J=AdpFun(x,k,yest,yreal,u)
J=0;
L=10;          % Ҫ��������ʱ�䴰����һ��
beta=zeros(1,L);
for i=1:L
    beta(i)=0.95^(L-i);             % ��������
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