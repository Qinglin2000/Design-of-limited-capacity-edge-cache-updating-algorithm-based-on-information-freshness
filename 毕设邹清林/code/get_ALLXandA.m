function [X_ALL,A_ALL] = get_ALLXandA(Decision,F,T,K)
%% ***********************获得所有决策计算的X(tf)与A(tfi)*******************************
%根据决策计算X，A的矩阵,计算所有决策K下的X和A
X_ALL=[];
A_ALL=[];
%使用k遍历
for k=1:1:K    
    subDecision=Decision((k-1)*2*F+1:k*2*F,:);%取得一种决策
    
    %*********************计算一种决策下的X和A******************************
    %计算AoI
    AoI=AoI_table(subDecision); %得到每个内容的AoI
    %X
    X=zeros(F,T);% X(tf):t时刻文件f是否在缓存中
    for t=1:1:T
        for f=1:1:F
            if subDecision(2*f,t)==1
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
    %**********************************************************************
    %将所有的X，所有的A合并
        X_ALL=[X_ALL;X];
        A_ALL=[A_ALL;A]; 
    %**********************************************************************
end

end
