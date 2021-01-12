%% 画每代的粒子群与最佳粒子
function oldPlot=plotPop(pop,y,i,y_z_best,z_best,oldPlot)
if oldPlot~=0
    delete(oldPlot);
end
subplot(3,1,[1,2]);   % 每代的粒子群
oldPlot=plot3(pop(:,1),pop(:,2),y,z_best(1),z_best(2),y_z_best,'ro','MarkerSize',10,'LineWidth',2);  % 画粒子群
set(oldPlot(1),'MarkerSize',10,'Marker','*', 'LineWidth',2,'LineStyle','none','MarkerEdgeColor','b')
% oldPlot=plot3(pop(:,1),pop(:,2),y,z_best(1),z_best(2),y_z_best,'ro','MarkerSize',10,'Marker','*', 'LineWidth',2,'LineStyle','none');  % 画粒子群
% oldPlot=plot3(pop(:,1),pop(:,2),y,'b*','LineWidth',2,'markersize',10);  % 画粒子群
hold on;drawnow;
subplot 313;          % 每代的最佳粒子
plot(i,z_best(1),'o',i,z_best(2),'*','LineWidth',2,'markersize',5);
hold on;
pause (0.1);
% 将每次迭代的结果保存成图片
% set(gcf,'PaperPositionMode','auto');  % 按当前窗口大小复制图片
% fn=sprintf('%d.png',i);
% h_fig=gcf;
% print(h_fig,'-dpng',fn)
end