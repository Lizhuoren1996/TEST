%%   debug fcm
rng(1)
data = rand(100,2);
[center,U,obj_fcn] = fcm(data,2);
%%
plot(data(:,1), data(:,2),'o');
hold on;
maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);
line(data(index1,1),data(index1,2),'marker','*','color','g');
line(data(index2,1),data(index2,2),'marker','*','color','r');
plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
hold off;
%%   debug subclust
clear;  clc;  clf;    rng(1)
X1 = 10*rand(50,1);  X2 =  5*rand(50,1);  X3 = 20*rand(50,1)-10;  X = [X1 X2 X3];
load('clusterdemo.dat');   X=clusterdemo;
[C,S] = subclust(X,[0.5 0.25 0.3],'Options',[2.0 0.8 0.7 1]);
%%
figure(1); clf;  
plot3(X(:,1),X(:,2),X(:,3),'ro')  
%%
figure(1);  clf ;
subplot 211;plot(potVals);hold on; plot(maxPotIndex,potVals(maxPotIndex),'ro','markersize',10,'linewidth',2);hold off;
subplot 212;plot3(X(:,1),X(:,2),X(:,3),'bo') ;hold on; plot3(centers(:,1),centers(:,2),centers(:,3),'ro','markersize',10,'linewidth',2);hold off;
view([-28 77]);