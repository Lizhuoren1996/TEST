function a=gray2num(g)
%% ������תʮ����
% d-������
% a--ʮ����
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