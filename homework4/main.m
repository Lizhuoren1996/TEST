%% 1911055��׾��
% clc; clear;
% num=[1]; den=[1 1];              % һ��ϵͳ
% den=[1 0.6 1];
% num=[0.04798 0.0464]; den=[1 -1.81 0.9048];
% noiseAmp=0.1;
% sys = tf(num,den);
sys=linsys1;
%% ʱ�����
tmp = stepinfo(sys);
Ts=tmp.SettlingTime
%% ȡ-3dB
[mag,ph,w]=bode(sys);   %���η��ط�Ƶ����Ƶ����Ƶ��
mag = 20*log10(squeeze(mag));    % dB
% plot(mag,w)
w0=spline(mag,w,mag(1)-3)    % rad/s 

%% ����M/IM���в���
fM=w0/2/pi     % Hz
delta=0.3/fM 
delta = 30;     %���������ֵ���ֶ�ȡֵ
Np=[1/(fM*delta),1.2*Ts/delta,1.5*Ts/delta]    %ȷ��M���еĳ���

M_Np=max(round(max(Np)),7); 
M_T=M_Np*delta;
M_Np=M_Np*2;
M_T=M_T*2;
M_d=delta;
if M_T>Ts
    disp('M�������ڴ���ԭʼϵͳ')
end
simTime=11*M_T
%%
sim('mysysIM.slx');

%%
Q=iddata(myout,myin,M_d);
figure(2)
plot(Q);%������װ�������������
dataStart = M_T/M_d;    
Qe = Q([dataStart:end]);%       ȥ��һ������
Qd=detrend(Qe);     %ȥ������
% plot(Qe,Qd);
Qde=Qd([1:end/2]);  %ǰһ��������������
Qdv=Qd([end/2+1:end]);  %��һ������������֤
figure(3)
plot(Q,Qd,Qde,Qdv);
%% ident
NN=struc(1:10,1:10,1:10);
Loss_fun= arxstruc(Qde,Qdv,NN);
order =[4 4 1];

Model=arx(Qde,order)

figure(4)
compare(Qdv,Model);%Ԥ�������ʵ����Ƚ�
figure(5)
resid(Model,Qde); %ģ��Ԥ������ط���


Model_tf_d=tf(Model) %��ɢģ��
Model_tf_c=d2c(Model_tf_d) %����ģ��
% Model_tf_c=d2c(Model_tf_d,'tustin')

num=cell2mat(Model_tf_d.num)
den=cell2mat(Model_tf_d.den)
num1=cell2mat(Model_tf_c.num)
den1=cell2mat(Model_tf_c.den)
sim('myverify2.slx')


% plot(simVerifyOut.time,simVerifyOut.signals.values(:,1),simVerifyOut.time,simVerifyOut.signals.values(:,2));












