function [num,scheme] = Queen(n)
global SCHEME_MATRIX N CURROW
N=n;SCHEME_MATRIX=zeros(1,n);%һ���շ���
CURROW=1;search;%����
scheme=SCHEME_MATRIX(1:(end-1),:);
num=size(scheme,1);

function search()
global SCHEME_MATRIX N CURROW
for i=1:N%�ڵ�ǰ����������
    if checkchess(CURROW,i) %�����������
        SCHEME_MATRIX(end,CURROW)=i;%�ڵ�ǰ�з���ʺ�
        if(CURROW<N) CURROW=CURROW+1;search;%������һ������
        else %�������һ�з���ʺ�����µķ�����
            SCHEME_MATRIX=[SCHEME_MATRIX;SCHEME_MATRIX(end,:)];
            break;
        end
    end
end
CURROW=CURROW-1;       %���ݵ���һ��, ��������

function result=checkchess(row,col)
global SCHEME_MATRIX
for i=1:(row-1);                  %���бȽ�
    if SCHEME_MATRIX(end,i)==col||abs(i-row)==abs(SCHEME_MATRIX(end,i)-col)
        result=0; return;
    end
end
result=1;                          %û�г��ֻṥ�������, ������
