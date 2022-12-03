function newdecision = dijkstra_pathtodecision(path,T)
% 由dijkstra求得的最短路径得到新的决策

newdecision=[];
index_Vt0=[];
index_Vt10=[];
counter=2;

for t=1:1:T
    counter=counter+t;      %计算特殊点
    index_Vt0(1,t)=counter;
    index_Vt10(1,t)=counter+1;
end

%%对path的每个元素进行判断
for n=3:1:length(path)-1
    if ismember(path(1,n),index_Vt0)==1    %是一个vt0点
        index=find(index_Vt0==path(1,n)); %获得这个点代表的时隙t=index
        newdecision(1,index)=0;
        newdecision(2,index)=0;
    elseif ismember(path(1,n),index_Vt10)==1 %是一个vt10点
        index=find(index_Vt10==path(1,n));%获得这个点代表的时隙t=index
        newdecision(1,index)=1;
        newdecision(2,index)=1;
    else   %是其他点
        index=min(find(index_Vt0>path(1,n)))-1;%t
        if isempty(index)== 0 %非最后一时隙
            newdecision(1,index)=1;
            newdecision(2,index)=0;
        else %最后一时隙
            newdecision(1,T)=1;
            newdecision(2,T)=0;
        end
    end
end
end

