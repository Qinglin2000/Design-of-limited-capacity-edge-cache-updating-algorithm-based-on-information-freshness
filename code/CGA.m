function [w,Decision,K,obj] = CGA(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S,m,K,Decision)
% Column Generation Algorithm,CGA
% 列生成算法
%%说明
% Input: S, cb, cs, λ=Lambda, lf , f ∈ F , o(u, r) and h(u, r), u ∈ U ,
% r ∈ R u
% Output: w∗

%% *********************************RMP与SP**********************************
%K用来记录迭代次数
b1=ones(1,T)*S;
b2=ones(1,F);
b=[b1 b2]';%b表示模型的资源系数,共T+F个值，前T个系数为S，后F个系数为1
e1=ones(1,T)*-1;
e2=zeros(1,F);
e=[e1 e2];%e确定不等式的情况，e(i)<0表示小于，e(i)=0表示等于，e(i)>0表示大于
stop=0;

while(stop==0)
    % ******************************* RMP *******************************************    
    [X_ALL,A_ALL] = get_ALLXandA(Decision,F,T,K);%计算所有情况下的（X，A）
    Cfk_ALL=get_ALLCfk(Decision,X_ALL,A_ALL,lf,F,T,cb,cs,m,K);
    [AoI,P]=get_AoIandPfi(Decision((K-1)*2*F+1:K*2*F,:),lf,T); %得到该次决策的AoI和Pfi
    TargetMatrix=get_Target_Matrix(Cfk_ALL);%获得目标函数矩阵(扁平化的),注意Cfk的列数会随迭代次数改变，每次添加新决策都多列
    %且Cfk排列时内层为f外层为k，如cfk：c11+c21+c31+...+cF1+c12+c22+c32+..+c1K+c2K+...+cFK.
    ConstraintsMatrix=get_Constraints_Matrix(lf,T,K,F,X_ALL);%获得约束系数矩阵，共T+F行，F*K列
    vlb=zeros(length(TargetMatrix));%vlb表示变量的下限0
    vub=ones(length(TargetMatrix));%vub表示变量的上限1
    
    RMP=lp_maker(TargetMatrix,ConstraintsMatrix,b,e,vlb,vub,[],[],1);%创建最小化线性规划模型，lp表示该模型的名字
    mxlpsolve('solve', RMP);
    obj=mxlpsolve('get_objective',RMP);
    w=mxlpsolve('get_variables',RMP);
    dual=mxlpsolve('get_dual_solution',RMP); %得到对偶变量共F*K+T+F个，问题：哪些对偶变量是我需要的？
    pi_t=dual(1:1:T);
   %beta_f=[dual(2+T+F-1,1); dual(2+T:1:2+T+F-2,1)];
    beta_f=dual(T+1:1:T+F);
    stop=1;
    
    % *********************************** SP ***************************************    
    %利用dijkstra算法得到新决策
    newdecision=[];
    for f=1:1:F
        [adj_martix,dijkstra_s,dijkstra_t]=dijkstra_getparameter(T,lf,m,cs,cb,P,pi_t,beta_f,f);
        [~, Route] =Dijkstras(adj_martix, dijkstra_s,dijkstra_t);
        newdecisionpart=dijkstra_pathtodecision(Route,T); %取得1个文件的新决策
        newdecision=[newdecision;newdecisionpart];
    end
    
    %将新决策与原决策比较并得到结果
    [X,A] = get_XandA(newdecision,F,T);
    Cfk_temp = get_Cfk(newdecision,X,A,lf,F,T,cb,cs,m); %获得新决策下的Cfk，并且与原决策的Cfk进行比较
    %reduced_cost=get_ReducedCost(newdecisionpart,T)
    %得到新决策
    for f=1:1:F
        if Cfk_temp<= Cfk_ALL(F,K) %对原问题没有改进
            %原决策不变
            newdecision(2*f-1,:)=Decision((K-1)*2*F+2*f-1,:);
            newdecision(2*f,:)=Decision((K-1)*2*F+2*f,:);
        end
    end
    %如果新决策与原决策相同，说明已经得到了最优解
    if newdecision == Decision((K-1)*2*F+1:K*2*F,:)
        %已经得到最优解
        break;
    else%不是最优解，将新决策加入原决策组
        Decision=[Decision;newdecision];
        stop=0;
    end
    K=K+1;    
end
%此步骤后，最后一组decision为最优决策，再计算一次得到与其对应的w

%% *************************计算最优decision与对应的的w*********************************

[X_ALL,A_ALL] = get_ALLXandA(Decision,F,T,K);%计算所有情况下的（X，A）
Cfk_ALL=get_ALLCfk(Decision,X_ALL,A_ALL,lf,F,T,cb,cs,m,K);
[AoI,P]=get_AoIandPfi(Decision((K-1)*2*F+1:K*2*F,:),lf,T); %得到该次决策的AoI和Pfi
TargetMatrix=get_Target_Matrix(Cfk_ALL);%获得目标函数矩阵(扁平化的),注意Cfk的列数会随迭代次数改变，每次添加新决策都多列
%且Cfk排列时内层为f外层为k，如cfk：c11+c21+c31+...+cF1+c12+c22+c32+..+c1K+c2K+...+cFK.
ConstraintsMatrix=get_Constraints_Matrix(lf,T,K,F,X_ALL);%获得约束系数矩阵，共T+F行，F*K列
vlb=zeros(length(TargetMatrix));%vlb表示变量的下限0
vub=ones(length(TargetMatrix));%vub表示变量的上限1
RMP=lp_maker(TargetMatrix,ConstraintsMatrix,b,e,vlb,vub,[],[],1);%创建最小化线性规划模型，lp表示该模型的名字
mxlpsolve('solve', RMP);
obj=mxlpsolve('get_objective',RMP);
w=mxlpsolve('get_variables',RMP);

end %下面使用RA算法对该决策进行修改


