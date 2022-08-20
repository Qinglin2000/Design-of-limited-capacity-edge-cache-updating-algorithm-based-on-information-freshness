function ConstraintsMatrix = get_Constraints_Matrix(lf,T,K,F,X_ALL)
%% ***********************得到CGA的约束系数矩阵*******************************
%容量约束，每行有F*K’个变量,共T行 (F乘以迭代次数个变量/行）
partA=[];
for t=1:1:T
    singleline=zeros(1,F*K);
    for k=1:1:K
        for f=1:1:F
            singleline(1,(k-1)*F+f)=lf(f,1)*X_ALL((k-1)*F+f,t);
            %排列规则：内层为f外层为k，如cfk：c11+c21+c31+...+cF1+c12+c22+c32+..+c1K+c2K+...+cFK.
        end
    end
    partA=[partA;singleline];     
end

%wfk二进制约束，每行有K’个变量为1，且要对应cfk的排列规则，共F行
partB=zeros(F,F*K);
    for f=1:1:F
        for k=1:1:K
            partB(f,(k-1)*F+f)=1;
        end
    end
    
%合并  
ConstraintsMatrix=[partA;partB];
end

