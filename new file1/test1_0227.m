function myGIF(name,frame,k)
%gif�ļ����ý�������͹رն���

filename = stract(name,'.gif')
im = frame2im(frame);
[l,map] = rgb2ind(im,256);          %ת��gifs��Ƭ��ֻ����256ɫ
if = k == 1
    imwrite(l,map,filename,'GIF','Loopcount',inf,'DelayTime',0.1);
else
    imwrite(l,map,filename,'GIF','WriteMode','append','DelayTime',0.1);
end
end
