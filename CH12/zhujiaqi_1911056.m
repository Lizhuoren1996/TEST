%% ���Է���ϵͳ��ֱ�������ʱ��ͽ�ֹƵ��
%��ϵͳ�����Ļ�������������ݺ���
num=[1];
den=[1 1]; %һ��
sys=tf(num,den); %sys���γɵ�һ��ϵͳ�Ĵ��ݺ���
% %��ģ��ʱ ��ֱ���������������һ�����ݺ�����ɨƵ�ź����ֹƵ�ʵķ��������ˣ�ֱ����ͼ��ȡ����ʦ���ܸ�ģ������ʶ
% mdl='veh1_4_1_line';
% sys = linearize(mdl);
%% ��ͼ�ϻ�ȡ����stepͼ��bodeͼ��stepͼ�п���settingtime�õ�������ͼ�Լ���1��-3db
figure(1)
subplot 121; step(sys); grid on ;%grid on�����Ǵ�����
subplot 122; bode(sys); grid on ;

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

%����M����
fM=w0/2/pi; %�ȸ��ݽ�ֹ��Ƶ�ʼ����ֹƵ��
delta=0.3/fM  %ȷ���������ڣ�ȡֵҪС��d=0.3/fM
delta=1; %���������ֵ���Լ��ֶ�����������ȡֵ
Np=[1/(fM*delta),1.2*Ts/delta,1.5*Ts/delta]   %%ȷ��M���еĳ��ȣ���д��3��ȡֵ��ʽ������ֻѡ��һ��
M_Np=max(round(max(Np)),7)  %��ΪM�������ڵĳ���Ϊ7��15,31����Щ����Ȼ���Ӧȷ���Ĵ�������
M_T=M_Np*delta  %m���е�����,�������TS�����ȷ��һ��
M_d=delta; %M���еĲ�������
if M_T>Ts
    disp('M�������ڴ���ԭʼϵͳ')
end
simTime=11*M_T  %%M���е�����xM���е����ڳ��ȵõ��ܵ�ʱ�䣬���Ҫ��������simulinkģ���е�stop Time
%% ����ϵͳģ��
sim('mysys.slx')  %%���ò���M���е�simulinkģ�ͣ�������

%% ���ý�����ϵͳģ�͵������������ϵͳ��ʶ
Q=iddata(myout,myin,M_d); 
figure(2)
plot(Q); %������װ�������������
% ident  %��ϵͳ��ʶ�����䣺
% ����GUI�еĲ�������������д�ڽű�����
% ȥ��ֵ ��ȥ��һ�����ڣ����ֱ�ʶ�ͼ�������
dataStart=M_T/M_d; %����һ��M�������ڵĳ��ȣ�����ȥ����һ�����ȣ�����ȥ���˵�һ�����ڵ�Ӱ��
Qe = Q([dataStart:end]); %����Ӱ��ȥ����һ������
Qd = detrend(Qe);  %ȥ������
Qde = Qd([1:end/2]); %%ǰһ�������������ԣ��������б�ʶ������
Qdv = Qd([end/2+1:end]);  %��һ������������֤����������ģ����֤������
figure(3)
plot(Q,Qd,Qde,Qdv);
%% ident
NN = struc(1:10,1:10,1:10); %�״�ѡ��Χ
Loss_fun = arxstruc(Qde,Qdv,NN);  %��ʧ����
order = selstruc(Loss_fun);   %��ʶϵͳ�״Σ��ֶ�ѡ����������ʣ�
% order = selstruc(Loss_fun,'aic')
% order_aic = selstruc(Loss_fun,0)
Model = arx(Qde,order) % ARģ��
%% ��ȡģ�Ͳ���
Model_tf_d=tf(Model) %��ɢģ��
% Model_tf_c=d2c(Model_tf_d) %����ģ��
Model_tf_c=d2c(Model_tf_d,'tustin')
num1=cell2mat(Model_tf_c.num)
den1=cell2mat(Model_tf_c.den)
sim('myverify.slx')
figure(4)
compare(Qdv,Model); %Ԥ�������ʵ������Ƚ�
figure(5)
resid(Model,Qde); 
