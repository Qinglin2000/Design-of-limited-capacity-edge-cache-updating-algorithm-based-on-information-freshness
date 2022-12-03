%%所有希腊字母用英文读音表示，首字母大写
% 主程序
% Main Function


%% 0.initialization
clear;clc;close all; 

% %% 1.data input
% %*************输入参数，生成用户，计算h（u，r）与o（u，r)，计算AoI******************************
% %*************简化：每个时刻，每个用户一定发出且只发出一个请求**********************************
% U=20;
% T=10;
% cs=10; cb=1;
% F=20; 
% Lambda=0.5; 
% Gamma=0.54; 
% Rho=0.5;
% lf=randi([1 10],F,1);%每个文件的大小
% S=Rho*sum(lf(:));%缓存大小
% [Decision,content_requested,content_request_PMF,m] = get_request(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S);%生成初始化决策对
% 
% %% 2.CGA and RA
% %每次迭代decision都向下增加2*F列，Decision变量记录所有的决策情况
% [w,Decision,K,cost_CGA] = CGAandRA(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S,m,Decision);
% %% 3.LB
% cost_LB= LB(w,Decision,F,T,K,lf,cb,cs,m);
% %% 4.MPV 
% cost_MPV=MPV(content_requested,content_request_PMF,cb,cs,lf,F,T,S,m);
% %% 5.PBA
% cost_PBA=PBA(content_request_PMF,content_requested,T,F,cs,cb,lf,m,S);


%% 6.outplay results
for counter=1:1:6
    for index=1:1:5
        U=400;
        T=10;
        cs=8+2*counter; cb=1; 
        F=100;
        Lambda=0.5;
        Gamma=0.54;
        Rho=0.5;
        lf=randi([1 10],F,1);%每个文件的大小
        S=Rho*sum(lf(:));%缓存大小\
        S_LB=sum(lf(:));%求理论值的缓存大小
        [Decision,content_requested,content_request_PMF,m] = get_request(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S);%生成初始化决策对
        [Decision_LB,content_requested_LB,content_request_PMF_LB,m_LB] = get_request(U,T,F,cs,cb,Lambda,Gamma,1,lf,S_LB);%理论值的
        [w,Decision,K,~] = CGAandRA(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S,m,Decision);
        [w_LB,Decision_LB,K_LB,~] = CGAandRA(U,T,F,cs,cb,Lambda,Gamma,1,lf,S,m_LB,Decision_LB);
        cost_CGA1(1,index)=LB(w,Decision,F,T,K,lf,cb,cs,m);
        cost_LB1(1,index)=LB(w_LB,Decision_LB,F,T,K_LB,lf,cb,cs,m_LB);
        cost_MPV1(1,index)=MPV(content_requested,content_request_PMF,cb,cs,lf,F,T,S,m);
        cost_PBA1(1,index)=PBA(content_request_PMF,content_requested,T,F,cs,cb,lf,m,S);
    end
    cost_CGA(1,counter)=mean(cost_CGA1);
    cost_LB(1,counter)=mean(cost_LB1);
    cost_MPV(1,counter)=mean(cost_MPV1);
    cost_PBA(1,counter)=mean(cost_PBA1);
end
Cs=[10:2:20];
plot(Cs,cost_LB,'-r*',Cs,cost_MPV,'-b*',Cs,cost_PBA,'-g*',Cs,cost_CGA,'-k*','linewidth',1.5);
legend('理论值', 'MPV', 'PBA','CGA');
axis on;
ylabel('系统总成本');
xlabel('服务器下载成本/单位');

