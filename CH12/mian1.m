%% ϵͳ����
% num=[1];
% den=[1 1]; %һ��
sys= tf(num,den);

%% ������ֹƵ��
ts=0.001;   %%�����������λs
Tend=40;   %%����ʱ���ɨƵ����ʱ�䣬��λs�� ���ҲҪ����
Fstart=0;  %%ɨƵ��ʼƵ�� S
Fend=0.16;  %% ɨƵ����Ƶ�� Hz  �����ҲҪ����
fmax=0.151;  %% Hz ��ֹƵ�� ������ʹ����������֮��
w1=fmax*2*pi;  %%��ֹ���ǣ�Ƶ�� rad/s������Ҫ�������ֵ
sim('test_sys_characteristics.slx');  %% ����simulinkģ�ͣ�������
% ltiview(sys);  % ��LTI���ڽ���ϵͳ���Է���,ѡ��plot����Ϊstep ��bode������
figure(1)
subplot(1,2,1); 
step(sys); 
grid on ;
subplot(1,2,2); 
bode(sys); 
grid on ;
%% ʱ�����
tmp=stepinfo(sys);
Ts = tmp.SettlingTime%%stepͼ�п���settingtime�õ��ľ�������Ҫ�Ĺ���ʱ��

%% ��ͼ��ȡ-3dB
[mag,ph,w]=bode(sys);   %���η��ط�Ƶ����Ƶ����Ƶ��
mag=20*log10(squeeze(mag)); %dB  Ҳ����bode��magnitude=-3dbʱ��Ӧ��frequency����λ��rad/s����������Ҫ�Ľ�ֹƵ��
w0=spline(mag,w,mag(1)-3);  % rad/s mag(1)����M(0),����ʼ�ĵط�����mag��wȥ������������ֵ�������m0-3db����Ӧ��Ƶ�ʣ����ǽ�ֹƵ�ʡ�������find

%% ����M���в���
fM=w0/2/pi          %�ȸ��ݽ�ֹ��Ƶ�ʼ����ֹƵ��
delta=0.3/fM        %ȷ����������,ȡֵҪС��d=0.3/fM
%%
delta = 1;     %���������ֵ���ֶ�ȡֵ
Np=[1/(fM*delta),1.2*Ts/delta,1.5*Ts/delta]    %ȷ��M���еĳ���
%%
M_Np=max(round(max(Np)),7);            %������7��M��������3���Ĵ�������Ӧ����Ϊ7(2^N-1)
M_T=M_Np*delta
M_d=delta;
if M_T>Ts
    disp('M�������ڴ���ԭʼϵͳ')
end
simTime=7*M_T
%%
sim('mysys1.slx')
%% ���ý�����ϵͳģ�͵������������ϵͳ��ʶ
% Q=iddata(myout,myin,M_d);
% figure(2)
% plot(Q);
% ident
% 
% Qe=Q([1:50])
% Qed = detrend(Qe)
%%
Q=iddata(myout,myin,M_d)
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
order = selstruc(Loss_fun);

Model=arx(Qde,order)
%% ��ȡģ�Ͳ���
Model_tf_d=tf(Model) %��ɢģ��
Model_tf_c=d2c(Model_tf_d) %����ģ��
% Model_tf_c=d2c(Model_tf_d,'tustin')
num1=cell2mat(Model_tf_c.num)
den1=cell2mat(Model_tf_c.den)
sim('myverify1.slx')
figure(4)
compare(Qdv,Model);%Ԥ�������ʵ����Ƚ�
figure(5)
resid(Model,Qde); %ģ��Ԥ������ط���







