x1=1;x2=0;x3=1;x4=0;
m=60;
for i =1:m
    y4=x4;y3=x3;y2=x2;y1=x1;
    x4=y3;x3=y2;x2=y1;
    x1 = xor(y3,y4);
    if y4 ==0
        U(i)=-1;
    else
        U(i)=y4;
    end
end
M= U;
% stem(M)
stairs(M)
axis([0 60 -1.5 1.5] ) 