function [adj_martix,s,t] = dijkstra_getparameter(T,lf,m,cs,cb,P,pi_t,beta_f,file_index)
%计算针对某个文件f，dijkstra函数的参数
f=file_index;
threshold=10000;%判断一个点是否为邻居的距离门限
%计算C0
C0=[];
for t=1:1:T
    C0(1,t)=lf(f,1)*m(f,t)*cs;
end
C0=sum(C0,2);  

%计算C1
C1=lf(f,1)*(cs-cb);

%计算Vit，输入的Pf(i)应该采用最新一种决策的
V=[];%V为T*T的矩阵，横向为时隙T，纵向为AoI的i，为0到T-1
for t=1:1:T
    for i=1:1:T
        V(i,t)=m(f,t)*P(f,i);
    end
end

%计算Gt
%需要输入pi_t(T,1);
G=[];%G为F行T列的矩阵
for t=1:1:T
    G(1,t)=lf(f,1)*m(f,t)*(cs-cb)-lf(f,1)*pi_t(t,1);
end    

%% 计算adj_martix邻接矩阵

%需要给定f！！！！！！
dim=1+1+(2+T+1)*T/2+1;%维数：1+1+sum(t+1)+1,t从1到T

%**************************生成起点和第一个点的邻接矩阵**********************%
%为了区分，小于0的权设为0，而所有到Vt0的弧的权由0变为1，这样就区分开了
%line_S=ones(1,dim)*-threshold;
line_S=Inf(1,dim);
line_S(1,1)=0;
line_S(1,2)=C0;
line_S(line_S<0)=0;
%line_V00=ones(1,dim)*-threshold;
line_V00=Inf(1,dim);
line_V00(1,1)=C0;
line_V00(1,2)=0;
line_V00(1,3)=1;%到Vt0的弧的权变为1
line_V00(1,4)=C1-G(1,1);
line_V00(line_V00<0)=0;

adj_martix=[line_S;line_V00];
    
index_Vt0=[];
index_Vt10=[];
counter=2;

for t=1:1:T
    counter=counter+t;      %计算特殊点
    index_Vt0(1,t)=counter;
    index_Vt10(1,t)=counter+1;
end
%**************************生成中间的点的邻接矩阵***************************%
for n=3:1:dim-1         
    %newline=ones(1,dim)*-threshold; 
    newline=Inf(1,dim);
    newline(1,n)=0;
    if n==3  %是第一个vt0点
        newline(1,2)=1;
        newline(1,5)=1;
        newline(1,6)=C1-G(1,2);
    elseif n==4    %是第一个vt10点
        newline(1,2)=C1-G(1,1);
        newline(1,5)=1;
        newline(1,6)=C1-G(1,2);
        newline(1,7)=V(1,1)-G(1,2);
    elseif ismember(n,index_Vt0)==1 && n~=3  %是其他的vt0点
        index=find(index_Vt0==n);%获得这个点代表的时隙t=index
        if index~=T %非最后一个时隙
            newline(1,n-index:1:n-1)=1;
            newline(1,n+index+1)=1;
            newline(1,n+index+2)=C1-G(1,index+1);
        else %最后一个时隙
            newline(1,n-index:1:n-1)=1;
            newline(1,dim)=beta_f(f,1);
        end
    elseif ismember(n,index_Vt10)==1 && n~=4 %是其他的vt10点
        index=find(index_Vt10==n);%获得这个点代表的时隙t=index
        if index~=T %非最后一个时隙            
            newline(1,n-index-1:1:n-2)=C1-G(1,index);
            newline(1,n+index)=1;
            newline(1,n+index+1)=C1-G(1,index+1);
            newline(1,n+index+2)=V(1,index)-G(1,index+1);            
        else %最后一个时隙
            newline(1,n-index-1:1:n-2)=C1-G(1,index);
            newline(1,dim)=beta_f(f,1);
        end        
    else  %是其他点
        index=min(find(index_Vt0>n))-1;%t
        aoi=n-index_Vt10(1,index);  %i
        if isempty(index)== 0 %非最后一时隙
          newline(1,n-index-1)=V(aoi,index)-G(1,index);
          newline(1,index_Vt0(1,index+1))=1;
          newline(1,index_Vt10(1,index+1))=C1-G(1,index+1);
          newline(1,n+index+2)=V(aoi+1,index+1)-G(1,index+1);
        else %最后一时隙
          newline(1,n-index-1)=V(aoi,index)-G(1,index); 
          newline(1,dim)=beta_f(f,1);      
        end               
    end
   newline(newline<0)=0;
   adj_martix=[adj_martix;newline]; 
end
%**************************生成终点的邻接矩阵*******************************%
%line_D=ones(1,dim)*-threshold;
line_D=Inf(1,dim);
line_D(:,dim-T-1:1:dim-1)=abs(-beta_f(f,1));
line_D(1,dim)=0;
adj_martix=[adj_martix;line_D];

%% 计算s和t
s=1;
t=dim;
end

