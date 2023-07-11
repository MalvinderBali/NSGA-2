function population=crowding_distance_calculation(z,F,population)

nof=length(F);
for k=1:nof
    zk=z(F{k},:);
    nobj=size(zk,2);
    n=numel(F{k});
    d=zeros(n,nobj);
    for jk=1:nobj
        [cjk,icjk]=sort(zk(:,jk));
        d(icjk(1),jk)=inf;
        for ik=2:n-1
            d(icjk(ik),jk)=abs(cjk(ik+1)-cjk(ik-1))/abs(cjk(1)-cjk(end));
        end
        d(icjk(end),jk)=inf;
    end
    
    for i=1:n
        population((F{k}(i))).crowdingdistance=sum(d(i,:));
    end
end
end