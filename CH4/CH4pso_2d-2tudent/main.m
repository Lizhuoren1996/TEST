%% �˽�������������Խ����Ӱ��
clf; clear all; clc;
h_Fig=0;     % FIG���
stop = uicontrol('style','toggle','string','stop', ...
    'background','white');   % FIG������stop��ť

%% ��������
% ����⺯���Ĳ����������⺯���й�
par_num=2;                                        % ��������
popmax=5.12;popmin=-5.12;      % ����ȡֵ��Χ5.12
% PSO��������PSO�㷨�й�
c1=2;c2=2;
w_max=0.9;w_min=0.4;                     % ����Ȩ�صĳ�ʼ����ֵֹ
vmax=1;vmin=-1;                              % ������Χ
% �Ż�����
max_iterm=100;sizepop=25;           % ������������

plotFun(popmin,popmax);                 % ������ͼ

%% ���ӳ�ʼ��
for i=1:sizepop
    pop(i,:)=popmin+2*popmax*rand(1,par_num);
    v(i,:)=rands(1,par_num);  
    [ty(i),y(i)]=Adpfun(pop(i,:));
end
[best_y, best_index]=min(y);  % ��Ӧ�Ⱥ�������Сֵ/ȫ����С
z_best=pop(best_index,:);      % Ⱥ�弫ֵ
g_best=pop;                          % ���弫ֵ
y_g_best=y;                           % ���弫ֵ��Ӧ��ֵ
y_z_best=best_y;                   % Ⱥ�弫ֵ��Ӧ��ֵ

h_Fig=plotPop(pop,ty,i,y_z_best,z_best,h_Fig);   % ��ÿ������Ⱥ���������
%% PSO�����Ż�
isFlag=0;                          % -1:ֹͣ������0: �ﵽ������������1: �ﵽ����
stop_error=1e-4;                   % �����Ż��ľ���
stallnumMax=10;                     % ����ͣ�͵���������
stallError = 1e-6;                   % ͣ�͵����ľ���
for i=1:max_iterm   % ��ѭ����ʼ���������е����ӣ�һ��
    h_Fig=plotPop(pop,ty,i,y_z_best,z_best,h_Fig);   % ��ÿ������Ⱥ���������
    
    w=w_max-(i-1)*(w_max-w_min)/max_iterm;  % ���Եݼ�����Ȩ��
    
    for j=1:sizepop                         % �ٶȸ��º����Ӹ���
        % ��ѭ��������ÿһ������
        % -----------PSO��ʽ----------------
        %  v(j,:)=w*(v(j,:)+c1*rand*(g_best(j,:)-pop(j,:))+c2*rand*(z_best-pop(j,:)));
        v(j,:)=w*v(j,:)+c1*rand*(g_best(j,:)-pop(j,:))+c2*rand*(z_best-pop(j,:));   %�ٶȸ���
        % -----------PSO��ʽ----------------
        % Լ����ȡֵ��Χ
        v(j,v(j,:)>vmax)=vmax;        % �޶��ٶ�ȡֵ��Χ
        v(j,v(j,:)<vmin)=vmin;
        pop(j,:)=pop(j,:)+0.5*v(j,:);  % ����λ��(��ʽ2)
        pop(j,pop(j,:)>popmax)=popmax;  %����λ�÷�Χ
        pop(j,pop(j,:)<popmin)=popmin;
        % ���ӱ���
        if rand>0.9
            kk=ceil(par_num*rand);
            pop(j,kk)=rand; 
        end
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
end  % ��ѭ������
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