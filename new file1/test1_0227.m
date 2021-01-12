function myGIF(name,frame,k)
%gif文件不用建立对象和关闭对象

filename = stract(name,'.gif')
im = frame2im(frame);
[l,map] = rgb2ind(im,256);          %转成gifs是片，只能用256色
if = k == 1
    imwrite(l,map,filename,'GIF','Loopcount',inf,'DelayTime',0.1);
else
    imwrite(l,map,filename,'GIF','WriteMode','append','DelayTime',0.1);
end
end
