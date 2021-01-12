function [num,scheme] = Queen(n)
global SCHEME_MATRIX N CURROW
N=n;SCHEME_MATRIX=zeros(1,n);%一个空方案
CURROW=1;search;%搜索
scheme=SCHEME_MATRIX(1:(end-1),:);
num=size(scheme,1);

function search()
global SCHEME_MATRIX N CURROW
for i=1:N%在当前行逐列搜索
    if checkchess(CURROW,i) %满足放置条件
        SCHEME_MATRIX(end,CURROW)=i;%在当前行放入皇后
        if(CURROW<N) CURROW=CURROW+1;search;%进入下一行搜索
        else %已在最后一行放入皇后，添加新的方案行
            SCHEME_MATRIX=[SCHEME_MATRIX;SCHEME_MATRIX(end,:)];
            break;
        end
    end
end
CURROW=CURROW-1;       %回溯到上一行, 继续搜索

function result=checkchess(row,col)
global SCHEME_MATRIX
for i=1:(row-1);                  %逐行比较
    if SCHEME_MATRIX(end,i)==col||abs(i-row)==abs(SCHEME_MATRIX(end,i)-col)
        result=0; return;
    end
end
result=1;                          %没有出现会攻击的情况, 返回真
