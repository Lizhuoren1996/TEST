
num = [1];den = [1 1];
% num=[12];den=[0.24,3,1];

sys=tf(num,den);
% bode(sys);%ͼ�ϻ�ý�ֹƵ��
%% ����ϵͳ
% num=[12];
% den=[0.24,3,1];
% sys=tf(num,den);
% % bode(sys);
% ts=0.001;
% Tend=100;
% Fstart=0;
% Fend=0.08;
% fmax=0.055;
% w1=fmax*2*pi;
% sim('test_sys_characteristics.slx');
%%
ts=0.001;%�������
Tend=40;%����ʱ���ɨƵ
Fstart=0;%ɨƵ��ʼƵ��
Fend=0.16;
fmax=0.151;
w1=fmax*2*pi;%��ֹƵ��
sim('test_sys_characteristics.slx');