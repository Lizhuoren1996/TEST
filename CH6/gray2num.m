function a=gray2num(g)
%% 格雷码转十进制
% d-二进制
% a--十进制
% Example:
% gray2num('10111101010')

for i=1:length(g)
    t=0;
    for j=1:i
        t=bin2dec(g(j))+t;
    end
    d(i)=dec2bin(mod(t,2));
end
a=bin2dec(d);