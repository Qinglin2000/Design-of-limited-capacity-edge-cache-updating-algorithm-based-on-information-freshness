function [RAw,RADecision] = RA_all(w,Decision,K,T,F,S,lf)
%Rounding Algorithm,RA
% 舍入算法

%% RA算法
%对CGA得到的decision和w进行修改
%% line 1
RADecision=Decision; 
SPDecision=Decision((K-1)*2*F+1:1:K*2*F,:);%获得最后一组决策，也即与SP问题有关的那组
RAw=w;%获得决策对应的变量
[X_ALL,~] = get_ALLXandA(RADecision,F,T,K);
Z=get_Z(RAw,X_ALL,K,F,T);%根据决策计算Ztf;
S1=S;
Xset=zeros(size(X_ALL));
Fset=zeros(F,1);

%% line 2
% 对于时隙 t ∈ T 中的内容 f ∈ F，如果 ztf = 1，则决定存储内容。
for t=1:1:T
    for f=1:1:F
        if Z(f,t)==1
            for k=1:1:K
                X_ALL((k-1)*F+f,t)=1;
                Xset((k-1)*F+f,t)=1;
            end
            Fset(f,1)=1;
        end
    end
end
%% line 3
% 对于时隙 t ∈ T 中的内容 f ∈ F，如果 ztf = 1，则决定存储内容。
for t=1:1:T
    for f=1:1:F
        for k=1:1:K
            if X_ALL((k-1)*F+f,t)==0
                RAw((k-1)*F+f,1)=0;
            end
        end
    end
end

%% line 4 line 5
Z_lb=Z;
Z_lb(Z_lb<0.0001)=0;Z_lb(Z_lb>1)=1;
Z_lb1=Z_lb(Z_lb>0);
Z_lb1=Z_lb1(Z_lb1<1);
Z_lowerbound=min(Z_lb1);
[f_lowerbound,t_lowerbound]=find(Z==Z_lowerbound);
f_lowerbound=min(f_lowerbound);
%观察发现虽然f_lowerbound以及upperbound可能会有多个元素，但每个元素都指向同一个文件

%% line 6 line7
Z_ub=1-Z;
Z_ub(Z_ub<0.0001)=0;Z_ub(Z_ub>1)=1;
Z_ub1=Z_ub(Z_ub>0);
Z_ub1=Z_ub1(Z_ub1<1);
Z_upperbound=min(Z_ub1);
[f_upperbound,t_upperbound]=find(Z==(1-Z_upperbound));
f_upperbound=min(f_upperbound);

%% line 8 ---- line 16
%存疑，我修改了关于这些文件的所有的decision，但论文里只修改了有关这些文件的用于SP问题的decision --2022/5/4
%现在只修改最后一次的决策的xtf --2022/5/7
if(Z_lowerbound<Z_upperbound)
    for k=1:1:K
        X_ALL((k-1)*F+f_lowerbound,t_lowerbound)=0; 
        if X_ALL((k-1)*F+f_lowerbound,t_lowerbound)==1;
            RAw((k-1)*F+f_lowerbound,1)=0;
        end       
    end
elseif max(lf(f_upperbound,1))<S1
    for k=1:1:K
        X_ALL((k-1)*F+f_upperbound,t_upperbound)=1;
        Xset((k-1)*F+f_upperbound,t_upperbound)=1;
        Fset(f_upperbound,1)=1;
        if X_ALL((k-1)*F+f_upperbound,t_upperbound)==0;
            RAw((k-1)*F+f_upperbound,1)=0;
        end
    end
else
    for k=1:1:K
        X_ALL((k-1)*F+f_upperbound,t_upperbound)=0;
        if X_ALL((k-1)*F+f_upperbound,t_upperbound)==1;
            RAw((k-1)*F+f_upperbound,1)=0;
        end
    end
end

%% line 17 line 18
for f=1:1:F
    for k=1:1:K
        for t=1:1:T
            if X_ALL((k-1)*F+f,t)==1 && sum(X_ALL((k-1)*F+f,:))==1 && Xset((k-1)*F+f,t)==1; %%如果f文件的k组决策下x(t,f)只有一个时隙为1且其已被设为1
                RADecision((k-1)*2*F+2*f-1,t)=Decision((k-1)*2*F+2*f-1,t); %将对应的decision设为（x，0）
                RADecision((k-1)*2*F+2*f,t)=0;
            end
        end
    end
end

%% line 19 ---- line 25 
    S1=S-sum(lf(find(Fset==1))); %获得S'
for t=1:1:T
  for f=1:1:F 
      if lf(f,1)>S1 && ~ismember(f,find(Fset==1))
          for k=1:1:K
              X_ALL((k-1)*F+f,t)=0;
              if X_ALL((k-1)*F+f,t)==1
                  RAw((k-1)*F+f,1)=0;
              end              
          end
      end
    end
end

end

