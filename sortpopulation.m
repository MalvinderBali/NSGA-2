function [population,z,x,F]=sortpopulation(population,z,x)

%sort based on crowdimg distance

[~,sacd]= sort([population.crowdingdistance],'descend');
population =population(sacd);
zs=z(sacd, :);
xs= x(sacd, :);



% sort rank
[~,sar]=sort([population.rank]);
population =population(sar);
z=zs(sar, :);
x= xs(sar, :);

% update frot
ranks=[population.rank];
maxrank=max(ranks);
F = cell(maxrank,1);
for r=1:maxrank
    F{r}=find(ranks==r);
end



end