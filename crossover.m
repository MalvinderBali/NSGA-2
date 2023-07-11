function [y1,y2]=crossover(p1,p2,nv,min,max)
alpha=rand(1,nv);
y1=alpha.*p1+(1-alpha).*p2;
y2=alpha.*p2+(1-alpha).*p1;

for icontrol=1:nv
    if y1(icontrol)>max
        y1(icontrol)=max;
    end
    if y1(icontrol)<min
        y1(icontrol)=min;
    end
    if y2(icontrol)>max
        y2(icontrol)=max;
    end
    if y2(icontrol)<min
        y2(icontrol)=min;
    end
end
end