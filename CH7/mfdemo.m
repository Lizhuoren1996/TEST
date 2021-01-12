clear ;  clc; clf
x = linspace(-20, 20, 201);
%fisģ���ṹ  mf��������
mf = [fismf(@trapmf,[-19 -17 -12 -7])     % ����
         fismf(@gbellmf,[3 4 -8])                  % ���Σ�a-�� b-�������״ c-����
         fismf(@trimf,[-9 -1 2])                     % ������
         fismf(@gaussmf,[3 5])                     % ��˹����׼���ֵ
         fismf(@gauss2mf,[3 10 5 13])         % ��ϸ�˹: �����Ҳ�Ĳ���
         fismf(@smf,[11 17 ]) ]';                    % S�ͣ����㣬��1��
y = evalmmf(mf,x);%����
h=subplot(2,1,1);plot(x,y);
h.YLim=[0 1.2];
str={'trapmf', 'gbellmf', 'trimf', 'gaussmf', 'gauss2mf', 'smf'}; 
text([-15 -8 -1 5 12 18]', 1.08*ones(6,1),str, 'HorizontalAlignment', 'center')
mf = [fismf(@zmf,[-18 -10])                     % Z��: ��1 ����0��
         fismf(@psigmf,[2 -11 -5 -4])            % ����S�εĳ˻���
         fismf(@dsigmf,[5 -3 1 5])                % ������ͬ��S��
         fismf(@pimf,[0 7 11 15])                 % pi��
         fismf(@sigmf,[2 15]) ]';                    % S�Σ�a-���ɿ�ȣ�c-��������
y = evalmmf(mf,x);
h=subplot(2,1,2);plot(x,y);
h.YLim=[0 1.2];
str={'zmf', 'psigmf', 'dsigmf', 'pimf','sigmf'}; 
text([-18 -8 0 8 18]', 1.08*ones(5,1),str, 'HorizontalAlignment', 'center')

