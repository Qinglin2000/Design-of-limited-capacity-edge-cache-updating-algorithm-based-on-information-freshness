function [X,A] = get_XandA(Decision,F,T)
%% ***********************根据一种决策计算X(tf)与A(tfi)*******************************
%根据决策计算X，A的矩阵,这个函数每次只能计算一种决策下的X,A，如k=1，2，3....，不能计算所有决策K下的X和A
%计算AoI
AoI=AoI_table(Decision); %得到每个内容的AoI
%X
X=zeros(F,T);% X(tf):t时刻文件f是否在缓存中 
for t=1:1:T
    for f=1:1:F
        if Decision(2*f,t)==1
            X(f,t)=1;
        else
            X(f,t)=0;
        end
    end
end

%A
A=zeros(F,T^2); % A(tfi):t时刻文件f是否在缓存中,且具有i的AoI
for f=1:1:F
  for t=1:1:T  
        A(f,(t-1)*T+AoI(f,t)+1)=1; %每个时隙含有T列，分别代表i从0到t-1
    end
end
end

