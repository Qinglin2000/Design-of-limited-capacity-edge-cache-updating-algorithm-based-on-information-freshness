function Cfk_ALL = get_ALLCfk(Decision,X_ALL,A_ALL,lf,F,T,cb,cs,m,K)
%% ****************************计算所有决策下的C(f,k)*********************************
%注意：第n列对应第n次决策下的Cfk
Cfk_ALL=[];

%使用k遍历
for k=1:1:K    
    subDecision=Decision((k-1)*2*F+1:k*2*F,:);%取得一种决策
    X=X_ALL((k-1)*F+1:k*F,:);
    A=A_ALL((k-1)*F+1:k*F,:);
    
    %*********************计算一种决策下的Cfk******************************
    %计算AoI
    AoI=AoI_table(subDecision); %得到每个内容的AoI
    %计算内容存储成本Pfi
    P=repmat(lf,1,T).*AoI;%内容存储Pfi开销为内容大小和AoI的乘积
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
    subCfk=sum(C_download,2)+sum(C_update,2)+sum(C_AoI,2);
    
    %*********************所有决策下的Cfk合并******************************
    Cfk_ALL=[Cfk_ALL subCfk];
    %**********************************************************************
end
end