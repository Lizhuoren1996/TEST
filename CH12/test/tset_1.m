%% ϵͳ����
num=[1];
den=[1 1]; %һ��
sys=tf(num,den); %sys���γɵ�һ��ϵͳ�Ĵ��ݺ���
%% ������ֹƵ��
ts=0.001;   %%�����������λs
Tend=40;   %%����ʱ���ɨƵ����ʱ�䣬��λs�� ���ҲҪ����
Fstart=0;  %%ɨƵ��ʼƵ�� S
Fend=0.16;  %% ɨƵ����Ƶ�� Hz  �����ҲҪ����
fmax=0.151;  %% Hz ��ֹƵ�� ������ʹ����������֮��
w1=fmax*2*pi;  %%��ֹ���ǣ�Ƶ�� rad/s������Ҫ�������ֵ
sim('test_test_sys_characteristics.slx');  %% ����simulinkģ�ͣ�������
% ltiview(sys);  % ��LTI���ڽ���ϵͳ���Է���,ѡ��plot����Ϊstep ��bode������
%% ��ͼ�ϻ�ȡ����stepͼ��bodeͼ��stepͼ�п���settingtime�õ�������ͼ�Լ���1��-3db
figure(1)
subplot 211; step(sys); grid on ;%grid on�����Ǵ�����
subplot 212; bode(sys); grid on ;

%%ʱ���������ȡ��Ծ��Ӧ�Ĺ���ʱ��
tmp = stepinfo(sys);
Ts=tmp.SettlingTime %%stepͼ�п���settingtime�õ��ľ�������Ҫ�Ĺ���ʱ��

%%��ͼ��ȡ-3dB
[mag,ph,w]=bode(sys); %���η��ط�Ƶ����Ƶ����Ƶ��
mag = 20*log10(squeeze(mag)); %dB  Ҳ����bode��magnitude=-3dbʱ��Ӧ��frequency����λ��rad/s����������Ҫ�Ľ�ֹƵ��
%%��Ƶ���Ե�����mag����ͨ����ķŴ�����
%%��Bodeͼ�������õ��Ƿֱ�ֵ����Ҫ����20��log�ɽ��л��㡣
%%squeeze����ȥ��ά��Ϊ1��
w0=spline(mag,w,mag(1)-3) % rad/s mag(1)����M(0),����ʼ�ĵط�����mag��wȥ������������ֵ�������m0-3db����Ӧ��Ƶ�ʣ����ǽ�ֹƵ�ʡ�������find
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
% sim('test_1');

%����M����
fM=w0/2/pi; %�ȸ��ݽ�ֹ��Ƶ�ʼ����ֹƵ��
delta=0.3/fM  %ȷ���������ڣ�ȡֵҪС��d=0.3/fM
delta=1; %���������ֵ���Լ��ֶ�����������ȡֵ
Np=[1/(fM*delta),1.2*Ts/delta,1.5*Ts/delta]   %%ȷ��M���еĳ��ȣ���д��3��ȡֵ��ʽ������ֻѡ��һ��
M_Np=max(round(max(Np)),7)  %������7��M��������3���Ĵ�������Ӧһ��M�������ڵĳ���Ϊ7���������ڳ�����15����Ӧ4����λ�Ĵ���,Ϊʲô��15֮��ȡ��ֵ
M_T=M_Np*delta  %�ܵ�m���е�����
M_d=delta; %M���еĲ�������
if M_T>Ts
    disp('M�������ڴ���ԭʼϵͳ')
end
simTime=7*M_T  %%M���е�����xM���е����ڳ��ȵõ��ܵ�ʱ�䣬���Ҫ��������simulinkģ���е�stop Time
%%
sim('test_mysys.slx')  %%���ò���M���е�simulinkģ�ͣ�������
%% ���ý�����ϵͳģ�͵������������ϵͳ��ʶ
Q=iddata(myout,myin,M_d); %��������ʱ������ź�myout�������ź�myin��iddata����M_dָ��ʵ�����ݵĲ���ʱ�䡣
%ʹ��iddata�����װҪ��ʶ��ϵͳ�����������������ݡ�ϵͳ��ʶ����ʹ����Щ����ֵ������ģ�͡�ģ����֤����ʹ���������ֵΪ�����ṩ���룬
%ʹ���������ֵ�ȽϹ��Ƶ�ģ����Ӧ��ԭʼ���ݵ��Ǻϳ̶ȡ�
figure(2)
plot(Q); %������װ�������������
% ident  %��ϵͳ��ʶ�����䣺
% ����GUI�еĲ�������������д�ڽű�����
% ȥ��ֵ ��ȥ��һ�����ڣ����ֱ�ʶ�ͼ�������
dataStart=M_T/M_d; %����һ��M�������ڵĳ��ȣ�����ȥ����һ�����ȣ�����ȥ���˵�һ�����ڵ�Ӱ��
Qe = Q([dataStart:end]); %����Ӱ��ȥ����һ������
Qd = detrend(Qe);  %ȥ������
Qde = Qd([1:end/2]); %%ǰһ��������������
Qdv = Qd([end/2+1:end]);  %��һ������������֤
figure(3)
plot(Q,Qd,Qde,Qdv);
%% ident
NN = struc(1:10,1:10,1:10);
Loss_fun = arxstruc(Qde,Qdv,NN);
order = selstruc(Loss_fun);
% order = selstruc(Loss_fun,'aic')
% order_aic = selstruc(Loss_fun,0)
Model = arx(Qde,order) % ARģ��
sim('test_myverify.slx')
figure(4)
compare(Qdv,Model); %Ԥ�������ʵ����Ƚ�
figure(5)
resid(Model,Qde); 
