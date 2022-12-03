function cost_LB= LB(w,Decision,F,T,K,lf,cb,cs,m)
%获得边缘缓存函数的理论极限，存疑?
%基于RA和CGA获得的Decision和w

[A,~]=size(w);
LB_w=w;
for a=1:1:A
    if LB_w(a,1)<=0.5
        LB_w(a,1)=0;
    else LB_w(a,1)=1;
    end
end  
[X_ALL,A_ALL] = get_ALLXandA(Decision,F,T,K);
Cfk_ALL = get_ALLCfk(Decision,X_ALL,A_ALL,lf,F,T,cb,cs,m,K);
cost_LB= sum(get_Target_Matrix(Cfk_ALL)'.*LB_w);
end

