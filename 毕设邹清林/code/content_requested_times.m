function m=content_requested_times(content_requested,F,T)
%每个时刻每个文件被索引的次数
m=zeros(F,T);
for t=1:1:T
    for f=1:1:F
        m(content_requested(f,t),t)= m(content_requested(f,t),t)+1;
end
end
end

