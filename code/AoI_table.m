function AoI=AoI_table(m);
%%得到每个内容的AoI
%m矩阵表示决策，每两行代表一个文件，第一行为xf，第二行为af
[F,T]=size(m);%获取矩阵维度
AoI=zeros(F/2,T);
for t=2:1:T
    for f=1:1:F/2
           if m(2*f-1,t)==0&&m(2*f,t)==0%内容不缓存，AoI也为0
               AoI(f,t)=0;
           elseif m(2*f-1,t)==1&&m(2*f,t)==0%缓存但不更新，AoI+1
               AoI(f,t)=AoI(f,t-1)+1;
           elseif m(2*f-1,t)==1&&m(2*f,t)==1 %缓存且更新，AoI为0    
               AoI(f,t)=0;   
        end
    end
end

