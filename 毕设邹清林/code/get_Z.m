function Z = get_Z(w,X,K,F,T)
%根据决策计算Ztf
Zmartix=X.*w;
Z=zeros(F,T);
for f=1:1:F
    for t=1:1:T
        for k=1:1:K
            Z(f,t)=Z(f,t)+Zmartix((k-1)*F+f,t);
        end
    end
end
end
