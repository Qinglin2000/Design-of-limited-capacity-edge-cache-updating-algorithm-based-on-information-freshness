function cost= PBA(content_request_PMF,content_requested,T,F,cs,cb,lf,m,S)
%popularity-based algorithm 基于信息流行度考虑的边缘缓存更新算法
%采用论文中提到的r-UPP算法
%% 计算Pr
Pr=content_request_PMF./sum(content_request_PMF);%归一化得到pr
%% 计算LLR
LLRthreshold=0.05;%定义LLR判决门限

%% 每时刻文件请求判断
cost=0;
cache=zeros(F,T);
s1=0;
for t=1:1:T
    for f=1:1:F
        if ismember(content_requested(f,t),cache(:,t)) %如果请求的文件在缓存中
            %从缓存中提供给用户
            cost=cost+cb*lf(content_requested(f,t),1)*m(content_requested(f,t),t);
        else %如果不在缓存中，进行判断
            if s1+lf(content_requested(f,t),1)<=S %如果缓存能存下
                cache(f,t)=content_requested(f,t); %下载到缓存中
                s1=s1+lf(content_requested(f,t),1);
                cost=cost+cs*lf(content_requested(f,t),1)*m(content_requested(f,t),t);
            else %如果缓存存不下
                Prsum=0;
                for b=1:1:F
                    if cache(b,t)~=0
                        Prsum=Prsum+Pr(cache(b,t),t);%如果流行度小于Prsum与LLR门限之积，就定义为LLR文件
                    end
                end
                LLR=[];
                for b=1:1:F
                    if cache(b,t)~=0 && Pr(cache(b,t),t)<Prsum*LLRthreshold
                        LLR(b,1)=cache(b,t);
                    end
                end  
                s2=0;
                sumLLR=0;
                if isempty(LLR)
                    sumLLR=0;
                else
                    for b=1:1:length(LLR)
                        if LLR(b,1)~=0
                            s2=s2+lf(LLR(b,1),1);
                            sumLLR=sumLLR+Pr(LLR(b,1),t);
                        end
                    end
                end
               % Label=find(cache(:,t)>0 & Pr(cache(:,t),t)<Prsum*LLRthreshold); %找到所有LLR文件的索引
                if Pr(content_requested(f,t),t)> sumLLR && s1-s2+lf(content_requested(f,t),1)<=S%如果新文件的流行度够大且删去LLR后能存下
                    newcache=setxor(cache(:,t),LLR);%删去LLR
                    cache(:,t)=0;
                    for b=1:1:length(newcache)
                        cache(b,t)=newcache(b,1);
                    end
                    cache(f,t)=content_requested(f,t);
                    s1=s1-s2+lf(content_requested(f,t),1);
                    cost=cost+cb*lf(content_requested(f,t),1)*m(content_requested(f,t),t);
                else %不满足条件就不储存
                    cost=cost+cs*lf(content_requested(f,t),1)*m(content_requested(f,t),t);
                end
            end
        end
    end
    if t<=3
        cache(:,t+1)=cache(:,t); %缓存到下一时隙
    end
end

end

