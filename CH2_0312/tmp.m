clear clc;
A = 3;
k = 8;
M = 2^k;
x0 = 1;
for i=1:100
    x2 = A*x0;
    x1 = mod(x2,M);
    v(i) = 2*x1/M-1;
    x0 =x1;
end
plot(v,'r-o')