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