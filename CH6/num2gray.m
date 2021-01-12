function c=num2gray(a,L)
%% 二进制转格雷码
% a: 二进制
% L：二进制长度
% % Example:
% num2gray(1234,16)
b=dec2bin(a,L);
c(1)=b(1);
for i=1:L-1
    m=bin2dec(b(i));
    n=bin2dec(b(i+1));
    c(i+1)=dec2bin(xor(m,n));
    b
    c
end
