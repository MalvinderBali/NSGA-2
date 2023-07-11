function z=objective(x)
global P; % number of sensing devices
global n;
global R; % fog devices
global Q; % gate way devices;
global S;  % cloud servers
global n; %number of tasks
V=P+R+S; %Total number of processing devices
global CPU_requirement_LB;
global CPU_requirement_UB;
global arraival_frequency_LB;
global arraival_frequency_UB ;
global deadline_bound_LB;
global deadline_bound_UB;
global data_size_LB;
global data_size_UB;
global uploading_BW_LB;
global uploading_BW_UB;
global transmition_power_LB;
global transmition_power_UB;
 global OED; %Execution dead line
 global Afreq; %arrival frequency
 U=OED./ Afreq;%utilization factor
%formation of independent task tupple
global n1;     %n1 denotes the number of preceding tasks
global n2;     %n2 represents the total number of preceding tasks waiting in QC
global n3;     %n3 represents the total number of preceding taskswaiting in QN.
global Wa;     % weighting Que time
global f_CPU_cloud;
global lamda;
global n4;
%%
for i=1:n
        O(i,1)=CPU_requirement_LB+(rand(1)*(CPU_requirement_UB-CPU_requirement_LB)); %CPU requirement
        O(i,2)=arraival_frequency_LB+(rand(1)*(arraival_frequency_UB-arraival_frequency_LB)); %arrival frequency
       O(i,3)=deadline_bound_LB+(rand(1)*(deadline_bound_UB-deadline_bound_LB));  %deadline bound
        O(i,4)=data_size_LB+(rand(1)*(data_size_UB-data_size_LB)); %data size
end

%Decision matrix
%  D=randi([0 1],n,V); % first P nodes 
 D=zeros(n,V);
 %% Local Execution model
 P_cpu=CPU_requirement_LB+(rand(1,P)*(CPU_requirement_UB-CPU_requirement_LB)); %CPU constraint of Pj 
OPR=ones(1,n).*1900; %Processing density
f_CPU=ones(1,P).*2e9; %computation frequency of jth sensing device
K=1e-10; 
 for j=1:P
for i=1:n
       if P_cpu(j)>O(i,1)
       D(i,j)=1;
       end
    
end
 
 end
 for i=1:n
 D_CPU(i)=O(i,4).*OPR(i);
 end
 for i=1:P
     for j=1:n
         T(i,j)=(D(j,i)*D_CPU(i))/f_CPU(i);
         E(i,j)=K*D_CPU(i)*f_CPU(i);
     end
 end
 T=T'; % time delay of the ith task at jth sensor;
 E=E'; %power dissipation
 %% Remote Execution Model
 %randi([0,1],[n,R+S])
 x=x>0;
 Decision=reshape(x,[n,R+S]);
 D(:,P+1:end)=Decision;
Bij=20e6*ones(1,n);
Gi=rand(1,n); %Gain
Pi=transmition_power_LB+(transmition_power_UB-transmition_power_LB)*rand(1,n);
Tr=rand(1,n); % Data transmission rate;
for i=1:n
Dijup(i)=Bij(i)*(log2(1+((Pi(i)*Gi(i))/((Tr(i))^2))));
end
for i=1:n
    for j=P+1:V
        Tup(i,j)=(D(i,j)*O(i,4))/Dijup(i); %uploading time delay
        Eup(i,j)= Tup(i,j)*Pi(i);
    end
end
%% processing time at cloud

 for i=1:n
    for j=P+1:V
         Tv(i,j)=(D(i,j)*D_CPU(i))/f_CPU_cloud(j);
         Ev(i,j)=K*D_CPU(i)*f_CPU_cloud(j);
     end
 end
 %% down stream
 for i=1:n
Dijdown(i)=Bij(i)*(log2(1+((Pi(i)*Gi(i))/((Tr(i))^2))));
end
for i=1:n
    for j=P+1:V
        Tdown(i,j)=(D(i,j)*O(i,4))/Dijdown(i); %uploading time delay
        Edown(i,j)= Tdown(i,j)*Pi(i);
    end
end
%% %waiting_time


freq=f_CPU_cloud;
freq(1:length(f_CPU))=f_CPU;

for i=1:n
    for j=1:V
     Tw(i,j)=(lamda(i)*(D(i,j)* D_CPU(i))^2)/(freq(j)*(freq(j)-(lamda(i)*D(i,j)*D_CPU(i))));
    end
end
%%

 %%
 QQ=task_importance(U);
 %1---Very Urgent task
 %2--- Urgent task
 %3--- Moderate task
 %4--- Non Urgent task
 for i=1:n
     if QQ(i)==1
            Q_times(i,1)=sum(Wa*n1);
     end
     if QQ(i)==2
            Q_times(i,1)=sum(Wa*n1)+sum(Wa*n2);
     end  
     if QQ(i)==3
            Q_times(i,1)=sum(Wa*n1)+sum(Wa*n2)+sum(Wa*n3);
     end 
     if QQ(i)==4
         Q_times(i,1)=sum(Wa*n1)+sum(Wa*n2)+sum(Wa*n3)+sum(Wa*n4);
     end
 end
 T11=zeros(n,V-P);
T=[T T11];
total_delay_C=Tw+Tup+Tdown;
for i=1:n
    for j=1:V
        E_off(i,j)=(Q_times(i,1)+total_delay_C(i,j))*Pi(i)+ Edown(i,j);
    end
end
E_off=E_off(1,:);
z(1,1)=abs(sum(sum(E_off)));
z(2,1)=abs(sum(sum(total_delay_C)));

end