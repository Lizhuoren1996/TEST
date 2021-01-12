clf;
x=0:200;   % 年龄
n=length(x);
muY=ones(1,n);
muO=zeros(1,n);
index=find(x>25);
muY(index)=1./(1+((x(index)-25)/5).^2);   % 年轻
index=find(x>50);
muO(index)=1./(1+(5./(x(index)-50)).^2); % 年老
plot(x,muY,x,muO,'linewidth',2)
%%
fis = readfis('tipper');
