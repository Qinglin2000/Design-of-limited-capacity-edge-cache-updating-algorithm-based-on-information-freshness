function [AoI,P] = get_AoIandPfi(subDecision,lf,T)
AoI=AoI_table(subDecision); %得到每个内容的AoI
%计算内容存储成本Pfi
P=repmat(lf,1,T).*AoI;%内容存储Pfi开销为内容大小和AoI的乘积
end

