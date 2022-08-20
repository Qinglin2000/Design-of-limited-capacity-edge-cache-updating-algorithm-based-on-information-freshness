function TargetMatrix = get_Target_Matrix(Cfk_ALL)
%% ***********************得到CGA的目标系数矩阵*******************************
%获得目标矩阵
TargetMatrix =Cfk_ALL(:)';%cfk：c11+c21+c31+...+cF1+c12+c22+c32+..+c1K+c2K+...+cFK.

end

