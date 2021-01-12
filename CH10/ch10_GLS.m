function f=ch9_GLS()
alpha=1000;
epsilon=1e-3;
it=200;
mu=1;
out_gls=GLS(alpha,epsilon,mu,it)


function out_gls=GLS(alpha,epsilon,mu,it)
% alpha为充分大的数
% epsilon为充分小的数
% mu遗忘因子
% it为迭代次数
% out_gls输出待辨识参数
na=2;nb=1;nd=1;                   % na，nb，nd为待辨识参数个数
pk=alpha^2*eye(na+nb);       % P(0)
pdk=alpha^2;                        % Pd(0)
tk=epsilon*ones(1,na+nb)';    % 待辨识参数theta([a1 a2 b1])初值
dk=0;                                     % 待辨识参数D(d1)初值
u=load('PRBS.TXT');               % M序列，构造输入
e=load('Gauss.txt');                % 高斯白噪声
z(1)=u(1)+e(1);                      % 构造输出
z(2)=-0.35*z(1)+u(2)+0.85*u(1)+e(2);
z(3)=-0.35*z(2)-0.075*z(1)+u(3)+0.85*u(2)+e(3);
zs(1)=z(1);                             % 构造用于辨识参数 的输入输出zs(2)=z(2)+dk*z(1);
zs(3)=z(3)+dk*z(2);
us(1)=u(1);
us(2)=u(2)+dk*u(1);
us(3)=u(3)+dk*u(2);
i=4;
hist_tk=tk;                        
hist_dk=dk;                       
while(i<it)                              % 迭代it-4次
    z(i)=-0.35*z(i-1)-0.075*z(i-2)-0.425*z(i-3)+u(i)+0.85*u(i-1)+e(i);  %构造输出
    zs(i)=z(i)+dk*z(i-1);            % 计算z(k)估计值  
us(i)=u(i)+dk*u(i-1);               % 计算u(k)估计值
    hs=[-zs(i-1) -zs(i-2) us(i)]';  % 遗忘因子法最小二乘估计
    kk=pk*hs/(hs'*pk*hs+mu);
    tk=tk+kk*(zs(i)-hs'*tk);
    pk=1/mu*(eye(na+nb)-kk*hs')*pk;
    hist_tk=[hist_tk tk];                          % 保存 的辨识过程
    es1=z(i-1)+[z(i-2) z(i-3) -u(i-1)]*tk;  % 有色噪声构造
    es2=z(i)+[z(i-1) z(i-2) -u(i)]*tk;
    wk=-es1;                                          % w(k)
    kdk=pdk*wk/(wk*pdk*wk+mu);       % 参数D的遗忘因子最小二乘估计
    dk=dk+kdk*(es2-wk*dk);
    pdk=1/mu*(1-kdk*wk)*pdk;
    hist_dk=[hist_dk dk];                        % 保存D的辨识过程
    i=i+1;
end
out_gls=[hist_tk(:,end)' hist_dk(end)];   % 辨识结果
plot([hist_tk' hist_dk']);                         % 画出辨识过程
