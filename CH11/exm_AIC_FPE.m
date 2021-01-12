clear all;
N=300;                                                                                      % 观测数据长度
M1 = idpoly([1 -2.851 2.717 -0.865],[0 1 1 1],[1 0.7 0.2]);       % ARMAX模型
u = idinput(N,'prbs',[0 1]);                % 输入伪随机信号
e = normrnd(0,1,N,1);                      % 随机噪声
y1 = sim(M1,[u e]);                           % 模型仿真
Q= iddata(y1,u);  
h=plot(Q);                                        % 获得一批输入输出数据   
%%
AIC=zeros(5,5); FPE=zeros(5,5); 
for i=1:5                                            % ARMA(na,nb)模型中的na
    for j=1:i                                         % ARMA(na,nb)模型中的nb
        Model=armax(Q,'na',i,'nb',j,'nc',i,'nk',1);  % 根据给定模型阶次进行辨识
        AIC(i,j)=aic(Model);                   % 辨识结构的AIC准则
        FPE(i,j)=fpe(Model);                   % 辨识结构的FPE准则
    end
end
AIC                                                     % 输出AIC矩阵
FPE
