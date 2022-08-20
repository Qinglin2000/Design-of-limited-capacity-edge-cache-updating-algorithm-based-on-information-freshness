function [Decision,content_requested,content_request_PMF,m] = get_request(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S)
%生成用户请求与初始化决策对
[content_requested,content_request_PMF] = content_requested_label(Gamma,F,T);%每个时隙，请求文件的索引,即用户请求内容与时间的分布
m=content_requested_times(content_requested,F,T);%每个时隙,每个文件被索引的次数mtf
%生成初始化决策对（x，a)
%对一个内容f：每个时隙t内（xf,af)有三种可能（0，0）,（1，0),(1,1）分别表示不存，存储不更新，与更新
Decision=zeros(2*F,T);%生成决策组，每两行代表一个文件，第一行为xf，第二行为af,初始化为0
stop=0;
while(stop==0)
    K=1;
    [~,Decision,~,~]=CGA(U,T,F,cs,cb,Lambda,Gamma,Rho,lf,S,m,K,Decision);
    if sum(sum(Decision))==0
        Decision=zeros(2*F,T);
        [content_requested,content_request_PMF] = content_requested_label(Gamma,F,T);%每个时隙，请求文件的索引,即用户请求内容与时间的分布
        m=content_requested_times(content_requested,F,T); 
    else       
        stop=1;
    end
end
Decision=zeros(2*F,T);
end

