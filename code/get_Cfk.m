function Cfk = get_Cfk(Decision,X,A,lf,F,T,cb,cs,m)
%% ****************************计算一种决策下的C(f,k)*********************************
%计算AoI
AoI=AoI_table(Decision); %得到每个内容的AoI
%计算内容存储成本Pfi
P=repmat(lf,1,T).*AoI;%内容存储Pfi开销为内容大小和AoI的乘积
Cfk=zeros(F,1);
%C_download
C_download=zeros(F,T);
for f=1:1:F
    for t=1:1:T
    C_download(f,t)=lf(f,1)*m(f,t)*(cb*X(f,t)+cs*(1-X(f,t)));
    end
end

%C_update
C_update=zeros(F,T);
for f=1:1:F
    for t=1:1:T
    C_update(f,t)=lf(f,1)*(cs-cb)*A(f,(t-1)*T+1);
    end
end
%C_AoI
C_AoI=zeros(F,T);
for f=1:1:F 
    for t=1:1:T
    C_AoI(f,t)=P(f,t)*m(f,t)*AoI(f,t);
    end
end
Cfk=sum(C_download,2)+sum(C_update,2)+sum(C_AoI,2);
end

