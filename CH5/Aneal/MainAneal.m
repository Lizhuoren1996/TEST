%% function  [best_fval,best_route,Tb]=MainAneal(d,Tn,alpha,Tf)
% dΪ���о������꣬alpha Ϊ�¶ȵ���ϵ����TnΪ����˻������TfΪ��ֹ�¶�
clc ;  clear;  
figure(2);clf;
figure(1); clf;
stop = uicontrol('style','toggle','string','stop', ...
    'background','white');   % FIG������stop��ť
cityposition=importdata('cityposition.mat');
%
Tn=20;  alpha=0.3;  Tf=0;                                   % �������������������

d=squareform(pdist(cityposition));                     % ���о������
n=length(d);
L=100*n;                                                             % Markov���ĳ���
route=randperm(n);     fval=value(route,d);       % ��ʼ·���ͳ�ʼĿ��ֵ
best_fval=fval;    best_route=route;
t=fval;ii=0;Tc=1;Tb=0;t2=0;                               % ���ó�ʼֵ

%% ----------------------------------------
% ������ͼ
cityNum=length(cityposition(:,1));
x=cityposition(:,1);y=cityposition(:,2);
hp=plot(x,y,'-+') ; hold on;
set(hp,'XDataSource','x');set(hp,'YDataSource','y');
x0=x([1,cityNum]);y0=y([1,cityNum]);
h0=plot(x0,y0,'r-'); % hold off;
set(h0,'XDataSource','x0');set(h0,'YDataSource','y0');
hroute_text=text(x+30,y+50,num2cell(1:cityNum));
TLtext=strcat('Tc=',num2str(Tc),',i=',num2str(1),sprintf(',fval=%.1f',fval));
hTL_text=text(1200,3800,TLtext);

%% --------------------------------------------
while Tc<=Tn         % ��ѭ����ʼ-----------------------
    for i=1:L             % ��ѭ����ʼ======
        % ���������������֮���˳��ߵ�
        [fval_after,route_after,loc1,loc2]=exchange(route,d);    % �ı�·��
        route_old_new=[route;route_after];            % ����ǰ���·��
        e=fval_after-fval;
        if  e<0                                                         % ���ܸ���·��
            route=route_after;      fval=fval_after;
        else                                                             % ��һ�����ʽ��ܷ�����ֵ
            if exp(-e/t)>rand                                    % �µ�Ŀ��ֵ����ǰһ�Σ���һ���ĸ��ʽ�����ֵ
                route=route_after;  fval=fval_after;
            else
                route=route;           fval=fval;             % С�ڸ���ֵ����������ֵ
            end
        end
        if (fval_after<best_fval);                              % ��¼���ţ�����ֵ=0�����˳�ѭ��
            best_fval=fval_after;best_route=route_after;Tb=Tc;
        end;
        %----------FIG���½��--------------------
        if(i==L)
            newcity=cityposition(route,:);
            x=newcity(:,1);y=newcity(:,2);
            x0=x([1,cityNum]);y0=y([1,cityNum]);refreshdata;
            TLtext=strcat('Tb=',num2str(Tb),'Tc=',num2str(Tc),',i=',num2str(i),sprintf(',fval=%.1f',fval),'��������[',num2str(loc1),',',num2str(loc2),']');
            set(hTL_text,'string',TLtext);
            delete(hroute_text);hroute_text=text(x+30,y+50,num2cell(1:cityNum));
            drawnow; pause(0.1);
            if get(stop,'value')==1; break; end;
        end
        %--------------------------------------
        % ��ѭ���˳�������Ŀ�꺯��=0 �� ����6��Ŀ�꺯���ޱ仯
        if best_fval==0;      break;               end      % ������СֵΪ0���˳�
        if abs(e)<=1e-6;t2=t2+1;else;t2=0;end      % ��¼Ŀ�꺯�������ޱ仯�Ĵ���
        if length(t2)>=6;    break;               end      % ����6��Ŀ�꺯���ޱ仯���˳�
    end               % ��ѭ������================
    
    t=alpha*t;     % ���¶Ƚ��ͼ�Сt���������ֵ���ܸ��ʣ���t��С����أ�t��ֵ��Ŀ�꺯������ֵ
    Tc=Tc+1;
    if t==Tf;            break;end
    if (Tc-Tb)>Tn/2;break;end                              % ����Tn/2�˻��޸ı䣬�����˻�
    ii=ii+1;
    fval_sequence(ii)=fval;
    besefval_sequence(ii)=best_fval;
    pause(0.1);
    if get(stop,'value')==1; break; end;
end  % ��ѭ������ -----------------------
set(stop,'style','pushbutton','string','close',...
    'callback','close(gcf)');
figure(2);plot(fval_sequence);                             % Ŀ�꺯���仯ֵ
hold on;  plot(besefval_sequence,'r-'); hold off;
legend('fval','best-fval');

