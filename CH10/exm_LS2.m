V=[54.3,61.8,72.4,88.7,118.6,194.0]' ; % ����ֵV
P=[61.2,49.5,37.6,28.4,19.2,10.1]' ;     % ����ֵP
%logP=-alpha*logV+logbeta=[-logV,1]   [alpha;log(beta)]=HL*theta
for i=1:6                                              
     Z(i,1)=log(P(i));                                   % ��zL��ֵ
end
HL=[-log(V(1)),1;
        -log(V(2)),1;
        -log(V(3)),1;
        -log(V(4)),1;
        -log(V(5)),1;
        -log(V(6)),1];                                 % ��HL��ֵ
%  һ����ɷ�
c1=HL'*HL; c2=inv(c1); c3=HL'*ZL; c4=c2*c3;
alpha=c4(1); beta=exp(c4(2));
name={'alpha';'beta'};
par=[alpha;beta];
table(par,'RowNames',name)