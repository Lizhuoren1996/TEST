%%
num = 10; den =[1 3 10]
csys = tf(num,den);
Ts = 0.1;
dsys = c2d(csys,Ts)
step(csys,dsys)

%%
dnum = cell2mat(dsys.Numerator);
dden = cell2mat(dsys.Denominator);

step(tf(num,den),tf(dnum,dden,Ts))
%%