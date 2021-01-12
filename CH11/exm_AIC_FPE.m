clear all;
N=300;                                                                                      % �۲����ݳ���
M1 = idpoly([1 -2.851 2.717 -0.865],[0 1 1 1],[1 0.7 0.2]);       % ARMAXģ��
u = idinput(N,'prbs',[0 1]);                % ����α����ź�
e = normrnd(0,1,N,1);                      % �������
y1 = sim(M1,[u e]);                           % ģ�ͷ���
Q= iddata(y1,u);  
h=plot(Q);                                        % ���һ�������������   
%%
AIC=zeros(5,5); FPE=zeros(5,5); 
for i=1:5                                            % ARMA(na,nb)ģ���е�na
    for j=1:i                                         % ARMA(na,nb)ģ���е�nb
        Model=armax(Q,'na',i,'nb',j,'nc',i,'nk',1);  % ���ݸ���ģ�ͽ״ν��б�ʶ
        AIC(i,j)=aic(Model);                   % ��ʶ�ṹ��AIC׼��
        FPE(i,j)=fpe(Model);                   % ��ʶ�ṹ��FPE׼��
    end
end
AIC                                                     % ���AIC����
FPE
