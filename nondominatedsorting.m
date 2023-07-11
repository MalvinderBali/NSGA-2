function [population, F]=nondominatedsorting(population,z)
npop=numel(population);

for i=1:npop
    population(i).dominationcount=0;
    population(i).dominationset=[];
end
F{1}=[];
for i=1:npop
    for j=(i+1):npop
        p=population(i);
        q=population(j);
        if (z(i,:)<z(j,:))
           p.dominationset=[p.dominationset j];
           q.dominationcount=q.dominationcount+1;
        end
        
        if (z(j,:)<z(i,:))
            q.dominationset=[q.dominationset i];
            p.dominationcount=p.dominationcount+1;
        end
        population(i)=p;
        population(j)=q;
    end
  if population(i).dominationcount==0
      F{1}=[F{1} i];
      population(i).rank=1;
  end
end
  
  k=1;
  
  
  while true
      Q=[];
      for i=F{k}
          p=population(i);
          for j=p.dominationset
              q=population(j);
              q.dominationcount=q.dominationcount-1;
              
               if q.dominationcount==0
                   Q=[Q j];
                   q.rank=k+1;
               end
               population(j)=q;
          end
      end
      
      if isempty(Q)
          break;
      end
      F{k+1}=[Q];
      k=k+1;
  end
end           
    
