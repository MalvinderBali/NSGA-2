function [ym]=mutation (p,nv,sigma,min,max)
j=randi(nv);

ym=p;
ym(j)=p(j)+sigma.*randn;

if ym(j)<min
    ym(j)=min;
end
if ym(j)>max
    ym(j)=max;
end
end