%%
clf;
% rng('default');
rng(5);
rng
flag=0;   % 1=����ִ�У�0=����ִ��
%�趨Ŀ�꺯��ֵ
P = -1:.1:1;
T = [-.9602 -.5770 -.0729  .3771  .6405  .6600  .4609 ...
      .1336 -.2013 -.4344 -.5000 -.3930 -.1647  .0988 ...
      .3072  .3960  .3449  .1816 -.0312 -.2189 -.3201];
plot(P,T,'+');
title('Training Vectors');
xlabel('Input Vector P');
ylabel('Target Vector T');
% set(gcf,'PaperPositionMode','auto');  % ����ǰ���ڴ�С����ͼƬ
% print(gcf,'-dpng','1.png')
