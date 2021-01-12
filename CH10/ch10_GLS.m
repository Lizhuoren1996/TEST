function f=ch9_GLS()
alpha=1000;
epsilon=1e-3;
it=200;
mu=1;
out_gls=GLS(alpha,epsilon,mu,it)


function out_gls=GLS(alpha,epsilon,mu,it)
% alphaΪ��ִ����
% epsilonΪ���С����
% mu��������
% itΪ��������
% out_gls�������ʶ����
na=2;nb=1;nd=1;                   % na��nb��ndΪ����ʶ��������
pk=alpha^2*eye(na+nb);       % P(0)
pdk=alpha^2;                        % Pd(0)
tk=epsilon*ones(1,na+nb)';    % ����ʶ����theta([a1 a2 b1])��ֵ
dk=0;                                     % ����ʶ����D(d1)��ֵ
u=load('PRBS.TXT');               % M���У���������
e=load('Gauss.txt');                % ��˹������
z(1)=u(1)+e(1);                      % �������
z(2)=-0.35*z(1)+u(2)+0.85*u(1)+e(2);
z(3)=-0.35*z(2)-0.075*z(1)+u(3)+0.85*u(2)+e(3);
zs(1)=z(1);                             % �������ڱ�ʶ���� ���������zs(2)=z(2)+dk*z(1);
zs(3)=z(3)+dk*z(2);
us(1)=u(1);
us(2)=u(2)+dk*u(1);
us(3)=u(3)+dk*u(2);
i=4;
hist_tk=tk;                        
hist_dk=dk;                       
while(i<it)                              % ����it-4��
    z(i)=-0.35*z(i-1)-0.075*z(i-2)-0.425*z(i-3)+u(i)+0.85*u(i-1)+e(i);  %�������
    zs(i)=z(i)+dk*z(i-1);            % ����z(k)����ֵ  
us(i)=u(i)+dk*u(i-1);               % ����u(k)����ֵ
    hs=[-zs(i-1) -zs(i-2) us(i)]';  % �������ӷ���С���˹���
    kk=pk*hs/(hs'*pk*hs+mu);
    tk=tk+kk*(zs(i)-hs'*tk);
    pk=1/mu*(eye(na+nb)-kk*hs')*pk;
    hist_tk=[hist_tk tk];                          % ���� �ı�ʶ����
    es1=z(i-1)+[z(i-2) z(i-3) -u(i-1)]*tk;  % ��ɫ��������
    es2=z(i)+[z(i-1) z(i-2) -u(i)]*tk;
    wk=-es1;                                          % w(k)
    kdk=pdk*wk/(wk*pdk*wk+mu);       % ����D������������С���˹���
    dk=dk+kdk*(es2-wk*dk);
    pdk=1/mu*(1-kdk*wk)*pdk;
    hist_dk=[hist_dk dk];                        % ����D�ı�ʶ����
    i=i+1;
end
out_gls=[hist_tk(:,end)' hist_dk(end)];   % ��ʶ���
plot([hist_tk' hist_dk']);                         % ������ʶ����
