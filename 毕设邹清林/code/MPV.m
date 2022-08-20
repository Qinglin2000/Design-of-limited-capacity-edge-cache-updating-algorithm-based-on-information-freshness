function [cost] = MPV(content_requested,content_request_PMF,cb,cs,lf,F,T,S,m)
%MPV 是一种主动缓存策略，它使用视频流行度分布来缓存“最流行的视频”。MPV 既不根据用户请求更新缓存，也不实施任何缓存替换策略。唯一需要缓存更新的变化是视频流行度分布的变化。
%不考虑AOI，在这个决策中，每个时刻基站缓存都将全部更新

%% 计算每时刻基站内存储的文件,并计算基站存储与更新的成本
%视频流行度分布content_request_PMF
[PMF_descend,PMF_index]=sort(content_request_PMF,1,"descend");%得到降序排列的文件索引
BScache=zeros(F,T);
%计算存储的文件
for t=1:1:T
    sumS=0;
    for f=1:1:F
        if(sumS+lf(PMF_index(f,t),1)<=S)
            sumS=sumS+lf(PMF_index(f,t),1);
            BScache(f,t)=PMF_index(f,t);
        end
    end
end
costofcache=0;

for t=1:1:T
    for f=1:1:F
     costofcache=costofcache+lf(PMF_index(f,t),1)*(cs-cb);
    end
end
        
%% 如果内容在基站中就直接下载，否则从服务器提供给用户
costofdownload=0;
%每时刻基站内存储的文件BScache
%每时隙请求的文件索引content_requested
for t=1:1:T
    for f=1:1:F
        if(ismember(content_requested(f,t),BScache(:,t))) %如果请求的文件在基站缓存中
            %提供下载并计算成本
            costofdownload=costofdownload+cb*content_requested(f,t)*m(content_requested(f,t),t);
        else
            costofdownload=costofdownload+cs*content_requested(f,t)*m(content_requested(f,t),t);
        end
    end
end
%% 两成本相加作为返回值
cost=costofcache+costofdownload;
end

