function [a, P_a] = content_requested_label(alpha,number,T)
%zipf_dis generate the probability of zipf_distribution
%   P_acc shows the probability distribution function
%   P_each shows the probability density function
% have tested the reality.



P_each = zeros(1,number);    % 定义每个文件的概率
for i = 1 : number
    P_each(i) = i^(-alpha);
end
P_sum = sum(P_each(:));
P_each = P_each ./ P_sum;    % 根据齐夫公式得到概率

% % P_acc = zeros(1,number);
% % for i = 1 : number
% %     if i == 1
% %         P_acc(i) = P_each(i);
% %     else
% %         P_acc(i) = P_acc(i-1) + P_each(i);
% %     end
% % end

% % 或者
% % P_acc = cumsum(P_each);

N = number;           % 需要随机数的个数
a = zeros(N,T);  % 存放随机数的数列
P_a = zeros(N,T);% 随机数对应的概率
n = 0; 

for timeslot=1:1:T
    n = 0;
while n<N
    t = randperm(number,1);% 生成[1,200]随机整数
    r = rand(1);           % 生成[0,1]均匀分布随机数
    if r <= P_each(t)      % 如果随机数r小于f(t)，接纳该t并加入序列a中
        n = n + 1;         % 计数加一
        a(n,timeslot) = t;          % 第n个数的值为t
        P_a(n,timeslot) = P_each(t);% 第n个数的概率为P_each（t）
    end
end
end

end





