function [w,Decision,K,cost_CGA] = CGAandRA(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S,m,Decision)
%CGA and RA
w=[];
stop=0;
K=1;
[w,Decision,K,cost_CGA]=CGA(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S,m,K,Decision);
count=0;
while(stop==0)
     [w,Decision,K,cost_CGA]=CGA(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S,m,K,Decision);% w:二进制变量矩阵  
     w(w<0.0001)=0;w(abs(1-w)<0.0001)=1;%舍入掉浮点数误差
    if(all((rem(w,1)<0.01))||count == 5)%当得到的解是整数解时 rem:得到w对1取余的值，any：判断余数是否为0，全为0时返回值为false
        stop=1;
    else
    [w,Decision] =RA_all(w,Decision,K,T,F,S,lf);
    count=count+1;
    end
end
[w,Decision,K,cost_CGA]=CGA(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S,m,K,Decision);
w(w<0.0001)=0;w(abs(1-w)<0.0001)=1;
end

