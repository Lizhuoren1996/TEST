function exm_ga_01_gray
clc;clear all; clf;
isplot_scm=true; %false; %true;
% f(x) = 11sin(6x) + 7cos(5x), 0 <= x <= 2 * pi 
rng(1)
L = 16; % ���볤�ȡ��ö�����ʱ���������⾫�Ⱦ�����LԽ��������Խ�ߣ�������������
N = 32; % ��Ⱥ��ģ[20,100]����ʾÿһ����Ⱥ������������Ŀ��ȡСʱ��������㷨�������ٶȣ���������Ⱥ�Ķ����ԣ������������㷨���졣
%  ���ּ�������ȡ��ʱ���ֻ�ʹ���㷨Ч�ʽ��͡�
M=N*3/2; %M = 48;  % N=32
T = 100;   % ��ֹ����������[100��1000],ͨ��������Ⱥ��Ӧ�ȵ��ȶ����ʵʱ����T������
Pc = 0.8; % ������ʣ���Ҫ��������[0.4-0.99]���ϴ��Pc�����ƻ�Ⱥ�������γɵ�����ģʽ���������������̫��
% ����С��Pcʹ�����¸��壨�ر����������壩���ٶ�̫������������Ƿ�һ��ʹ�ý�����ʡ�ǰ��ʹ�ýϴ��Pc�����ڽ���Pc�Ա�����������
Pm = 0.03; % ������ʡ��ϴ��Pmʹ�Ŵ��㷨���������� ٯ���д���Ծ����С��Pm�۽����ر�����
% �ֲ�������һ���ڲ�ʹ�ý�������ʱPm=0.4-1�������뽻����������ʹ��ʱPm=0.0001-0.5
plotFun(100,0,2*pi,T);

%% �����ֵ-������Ⱦɫ��
for i = 1 : 1 : N 
    x1(1, i) = rand() * 2 * pi;                                 % ʵ������
    x2(1, i) = uint16(x1(1, i) / (2 * pi) * (2^L-1));    % 16λ��������
    grayCode(i,:) = num2gray(x2(1, i), L);              % ʵ��-������-������
end
% grayCode
%% ��ѭ����ʼ
for t = 1 : 1 : T   % ��������
%     t
    y1 = 11 * sin(6 * x1) + 7 * cos(5 * x1); 
    plotgrayCode(grayCode,'r.',isplot_scm);
    for i = 1 : 1 : M / 2                  % ѡ���ƣ���Ⱥ��32--->48
        [a, b] = min(y1); 
        grayCodeNew(i, :) = grayCode(b, :); 
        grayCodeNew(i + M / 2, :) = grayCode(b, :); 
        y1(1, b) = inf;
%         y1'
    end
    if isplot_scm;plotgrayCode(grayCodeNew,'go',isplot_scm);end

    for i = 1 : 1 : M / 2                 % ����
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

    for i = 1 : 1 : M                     % ����
        for j = 1 : 1 : L 
            if rand() < Pm 
                grayCodeNew(i, j) = dec2bin(1 -bin2dec(grayCodeNew(i, j))) ; 
            end
        end
    end
    if isplot_scm;plotgrayCode(grayCodeNew,'mp',isplot_scm);end
    
    [x3,y3]=DegrayCode(grayCode);
    for i = 1 : 1 : N                  % ѡ����Ⱥ��48---->32
        [a, b] = min(y3); 
        x1(1, i) = x3(1, b); 
        grayCode(i, :) = grayCodeNew(b, :); 
        y3(1, b) = inf; 
    end
end
y1 = 11 * sin(6 * x1) + 7 * cos(5 * x1);
[ybest,y_index]=min(y1);
disp('-----���ŵ�-------');
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
% ֻ�����������ĺ���
% colorbar;  print �Cdmeta  % print -dbitmap
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
    