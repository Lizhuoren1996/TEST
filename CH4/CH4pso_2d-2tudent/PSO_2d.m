% function POS_2d
%% �˽�������������Խ����Ӱ��
clf; clear all; clc;
h_Fig=0;     % FIG���
stop = uicontrol('style','toggle','string','stop', ...
    'background','white');   % FIG������stop��ť

%% ��������
% ����⺯���Ĳ����������⺯���й�
par_num=2;               % ��������     
popmax=5;popmin=-5;      % ����ȡֵ��Χ5.12
% PSO��������PSO�㷨�й�
c1=2;c2=2;
w_max=0.9;w_min=0.4;     % ����Ȩ�صĳ�ʼ����ֵֹ
vmax=1;vmin=-1;          % ������Χ
% �Ż�����
max_iterm=100;sizepop=25;           % ������������
 
plotFun(popmin,popmax);             % ������ͼ

%% ���ӳ�ʼ��
for i=1:sizepop                                   
    pop(i,:)=popmin+2*popmax*rand(1,par_num);
    v(i,:)=rands(1,par_num);
    [ty(i),y(i)]=Adpfun(pop(i,:));
end
[best_y, best_index]=min(y);  % ��Ӧ�Ⱥ�������Сֵ
z_best=pop(best_index,:);      % Ⱥ�弫ֵ
g_best=pop;                          % ���弫ֵ
y_g_best=y;                           % ���弫ֵ��Ӧ��ֵ
y_z_best=best_y;                   % Ⱥ�弫ֵ��Ӧ��ֵ

%% PSO�����Ż�
isFlag=0;                                % -1:ֹͣ������0: �ﵽ������������1: �ﵽ���� 
stop_error=1e-4;                   % �����Ż��ľ���
stallnumMax=0;                     % ����ͣ�͵���������
stallError = 1e-6;                   % ͣ�͵����ľ���
for i=1:max_iterm
    % ��ѭ�����������е����ӣ�һ��    
    h_Fig=plotPop(pop,ty,i,y_z_best,z_best,h_Fig);   % ��ÿ������Ⱥ���������
    
    w=w_max-(i-1)*(w_max-w_min)/max_iterm;  % ���Եݼ�����Ȩ��
    
    for j=1:sizepop                         % �ٶȸ��º����Ӹ���
        % ��ѭ��������ÿһ������
        % -----------PSO��ʽ----------------
        %  v(j,:)=w*(v(j,:)+c1*rand*(g_best(j,:)-pop(j,:))+c2*rand*(z_best-pop(j,:)));
        v(j,:)=w*v(j,:)+c1*rand*(g_best(j,:)-pop(j,:))+c2*rand*(z_best-pop(j,:));
        % -----------PSO��ʽ----------------
        
        % Լ����ȡֵ��Χ
        v(j,v(j,:)>vmax)=vmax;        % �޶��ٶ�ȡֵ��Χ
        v(j,v(j,:)<vmin)=vmin;
        pop(j,:)=pop(j,:)+0.5*v(j,:);  % �޶�����ȡֵ��Χ
        pop(j,pop(j,:)>popmax)=popmax;
        pop(j,pop(j,:)<popmin)=popmin;
        % ���ӱ���
        if rand>0.9;kk=ceil(par_num*rand);pop(j,kk)=rand; end   
        
        [ty(j),y(j)]=Adpfun(pop(j,:));  % ��������Ӧ��ֵ
        % ��ѭ������ 
    end
    e=abs(min(y)-y_z_best);          % ��Ӧ�Ⱥ������
    for j=1:sizepop                        % ��ֵ����
        if y(j)<y_g_best(j);g_best(j,:)=pop(j,:);y_g_best(j)=y(j);end  % ���¸��弫ֵ
        if y(j)<y_z_best;z_best=pop(j,:);y_z_best=y(j);end              % ����Ⱥ�弫ֵ
    end
    
    % �жϵ���ֹͣ����
    [e,stallnumMax]     % ������Ҫ��ʾ�����Ż�������Ҫ�۲�ı���
    if abs(e)<=1e-6;stallnumMax=stallnumMax+1;else;stallnumMax=0; end         % ��¼Ŀ�꺯�������ޱ仯�Ĵ���
    if stallnumMax>=6;      isFlag=-1; break;  end                % ����6��Ŀ�꺯���ޱ仯���˳�
    if y_z_best<=stop_error;  isFlag=1;   break ; end    % �������ﵽ���ȣ� 
    if get(stop,'value')==1; break; end;                 % �ֶ�ֹͣ
end
% ����STOP��ť����ʾ CLOSE
set(stop,'style','pushbutton','string','close',...
    'callback','close(gcf)');
%% ��ʾ��� 
str1=sprintf('ֹͣ����=%d;��������=%d,������=%d',isFlag,i,sizepop);
disp(str1);
str1=sprintf('���չ��Ʋ�����[%f,%f]',z_best(1),z_best(2));
disp(str1);
str1=sprintf('��Ӧ�Ⱥ���=%f; ������=%f',y_z_best,e);
disp(str1);
% end 
%------------------------------------------------------------------------
%% ����⺯��
function y=myFun(x)
y=(0.5-((sin(sqrt(x(:,1).^2+x(:,2).^2))).^2-0.5)./(1+0.001*(x(:,1).^2+x(:,2).^2)).^2);
% y=16+(x(:,1).^2-8*cos(2*pi*x(:,1)))+(x(:,2).^2-8*cos(2*pi*x(:,2)));
end

%% ��Ӧ�Ⱥ�������Сֵ
function [y,fval]=Adpfun(x)
y    = myFun(x);
% fval = y;   % ��ԭ������Сֵ 
fval = 1/y;   % ��ԭ�������ֵ
end

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

%% ��ÿ��������Ⱥ���������
function oldPlot=plotPop(pop,y,i,y_z_best,z_best,oldPlot)
if oldPlot~=0
    delete(oldPlot);
end
subplot(3,1,[1,2]);   % ÿ��������Ⱥ
oldPlot=plot3(pop(:,1),pop(:,2),y,z_best(1),z_best(2),y_z_best,'ro','MarkerSize',10,'LineWidth',2);  % ������Ⱥ
set(oldPlot(1),'MarkerSize',10,'Marker','*', 'LineWidth',2,'LineStyle','none','MarkerEdgeColor','b')
% oldPlot=plot3(pop(:,1),pop(:,2),y,z_best(1),z_best(2),y_z_best,'ro','MarkerSize',10,'Marker','*', 'LineWidth',2,'LineStyle','none');  % ������Ⱥ
% oldPlot=plot3(pop(:,1),pop(:,2),y,'b*','LineWidth',2,'markersize',10);  % ������Ⱥ
hold on;drawnow;
subplot 313;          % ÿ�����������
plot(i,z_best(1),'o',i,z_best(2),'*','LineWidth',2,'markersize',5);
hold on;
pause (0.1);
% ��ÿ�ε����Ľ�������ͼƬ
% set(gcf,'PaperPositionMode','auto');  % ����ǰ���ڴ�С����ͼƬ
% fn=sprintf('%d.png',i);
% h_fig=gcf;
% print(h_fig,'-dpng',fn)
end