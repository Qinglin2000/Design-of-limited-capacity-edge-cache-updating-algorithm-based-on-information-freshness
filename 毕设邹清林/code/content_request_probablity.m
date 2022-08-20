function [content_request_PMF,content_request_CDF] = content_request_probablity(F,Gamma)
%生成ZipF分布下的每个用户请求内容f的概率
%每个用户请求第f个内容的概率服从ZipF分布,并且在时间段内随机变化 
%初始化
content_request_PMF=zeros(F,1);
content_request_CDF=zeros(F,1);
%计算概率质量函数PMF https://blog.csdn.net/qq_36069590/article/details/83106894
%计算H(n,a)
for i=1:1:F
    h(i,1)=(1/i)^Gamma;
end
H=sum(h(:));
for f=1:1:F
    content_request_PMF(f,1)=1/(f^Gamma*H);
end
sum1=0;
for f=1:1:F
    sum1=0;
    for k=1:1:f
        sum1=sum1+content_request_PMF(k,1);
    end
    content_request_CDF(f,1)=sum1;
end
%这里成功得到了CDF


