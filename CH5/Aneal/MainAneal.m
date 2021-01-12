%% function  [best_fval,best_route,Tb]=MainAneal(d,Tn,alpha,Tf)
% d为城市距离坐标，alpha 为温度调节系数，Tn为最大退火次数，Tf为终止温度
clc ;  clear;  
figure(2);clf;
figure(1); clf;
stop = uicontrol('style','toggle','string','stop', ...
    'background','white');   % FIG上设置stop按钮
cityposition=importdata('cityposition.mat');
%
Tn=20;  alpha=0.3;  Tf=0;                                   % 以上三个参数任意给定

d=squareform(pdist(cityposition));                     % 城市距离矩阵
n=length(d);
L=100*n;                                                             % Markov链的长度
route=randperm(n);     fval=value(route,d);       % 初始路径和初始目标值
best_fval=fval;    best_route=route;
t=fval;ii=0;Tc=1;Tb=0;t2=0;                               % 设置初始值

%% ----------------------------------------
% 画城市图
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
while Tc<=Tn         % 外循环开始-----------------------
    for i=1:L             % 内循环开始======
        % 产生两个随机数，之间的顺序颠倒
        [fval_after,route_after,loc1,loc2]=exchange(route,d);    % 改变路径
        route_old_new=[route;route_after];            % 交换前后的路径
        e=fval_after-fval;
        if  e<0                                                         % 接受更优路径
            route=route_after;      fval=fval_after;
        else                                                             % 按一定概率接受非最优值
            if exp(-e/t)>rand                                    % 新的目标值差于前一次，以一定的概率接受新值
                route=route_after;  fval=fval_after;
            else
                route=route;           fval=fval;             % 小于概率值，不接受新值
            end
        end
        if (fval_after<best_fval);                              % 记录最优，最优值=0用于退出循环
            best_fval=fval_after;best_route=route_after;Tb=Tc;
        end;
        %----------FIG更新结果--------------------
        if(i==L)
            newcity=cityposition(route,:);
            x=newcity(:,1);y=newcity(:,2);
            x0=x([1,cityNum]);y0=y([1,cityNum]);refreshdata;
            TLtext=strcat('Tb=',num2str(Tb),'Tc=',num2str(Tc),',i=',num2str(i),sprintf(',fval=%.1f',fval),'交换城市[',num2str(loc1),',',num2str(loc2),']');
            set(hTL_text,'string',TLtext);
            delete(hroute_text);hroute_text=text(x+30,y+50,num2cell(1:cityNum));
            drawnow; pause(0.1);
            if get(stop,'value')==1; break; end;
        end
        %--------------------------------------
        % 内循环退出条件：目标函数=0 或 连续6次目标函数无变化
        if best_fval==0;      break;               end      % 距离最小值为0，退出
        if abs(e)<=1e-6;t2=t2+1;else;t2=0;end      % 记录目标函数连续无变化的次数
        if length(t2)>=6;    break;               end      % 连续6次目标函数无变化，退出
    end               % 内循环结束================
    
    t=alpha*t;     % 随温度降低减小t，与非最优值接受概率（随t减小）相关，t初值是目标函数最优值
    Tc=Tc+1;
    if t==Tf;            break;end
    if (Tc-Tb)>Tn/2;break;end                              % 连续Tn/2退火无改变，结束退火
    ii=ii+1;
    fval_sequence(ii)=fval;
    besefval_sequence(ii)=best_fval;
    pause(0.1);
    if get(stop,'value')==1; break; end;
end  % 外循环结束 -----------------------
set(stop,'style','pushbutton','string','close',...
    'callback','close(gcf)');
figure(2);plot(fval_sequence);                             % 目标函数变化值
hold on;  plot(besefval_sequence,'r-'); hold off;
legend('fval','best-fval');

