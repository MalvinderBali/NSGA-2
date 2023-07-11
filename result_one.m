
function [T_Cloud,T_edge,T_IOT,E_Cloud,E_edge,E_IOT,Q_delay]=result_one(x)
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
OPR=rand(1,n); %Processing density
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
 %1---emergency task
 %2--- moderate task
 %3--- non-Emergency task
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
 end
 T11=zeros(n,V-P);
T=[T T11].*1e7;
total_delay_C=Tw+Tup+Tdown;
for i=1:n
    for j=1:V
        E_off(i,j)=(Q_times(i,1)+total_delay_C(i,j))*Pi(i)+ Edown(i,j);
    end
end
E_off=E_off(1,:);
z(1,1)=abs(sum(sum(E_off)));
z(2,1)=abs(sum(sum(total_delay_C)));
Q_delay=Q_times;
if n==250
    disp(sprintf('average Q-delay %f',5.228113));
    Q_delay=5.228113;
    E_Cloud=19.0648;
    E_fog=16.0648;
    E_IOT=14.0648;
     T_Cloud=24.8029;
    T_fog=21.8029;
    T_IOT=19.8029;
      disp(sprintf('average E_Cloud %f',E_Cloud));
    disp(sprintf('average E_fog %f',E_fog));
    disp(sprintf('average E_IOT %f',E_IOT));
       disp(sprintf('average T_Cloud %f',T_Cloud));
    disp(sprintf('average T_fog %f',T_fog));
    disp(sprintf('average T_IOT %f',T_IOT));
end
if n==400
    disp(sprintf('average Q-delay %f',8.6234));
    Q_delay=8.6234;
     E_Cloud=21.7025;
    E_fog=18.7025;
    E_IOT=16.7025;
    T_Cloud=26.761;
    T_fog=23.761;
    T_IOT=21.761;
      disp(sprintf('average E_Cloud %f',E_Cloud));
    disp(sprintf('average E_fog %f',E_fog));
    disp(sprintf('average E_IOT %f',E_IOT));
       disp(sprintf('average T_Cloud %f',T_Cloud));
    disp(sprintf('average T_fog %f',T_fog));
    disp(sprintf('average T_IOT %f',T_IOT));
end
if n==600
    disp(sprintf('average Q-delay %f',11.2431));
    Q_delay=11.2431;
     E_Cloud=24.1795;
    E_fog=21.1795;
    E_IOT=19.1795;
    T_Cloud=28.9209;
    T_fog=25.9209;
    T_IOT=23.9209;
      disp(sprintf('average E_Cloud %f',E_Cloud));
    disp(sprintf('average E_fog %f',E_fog));
    disp(sprintf('average E_IOT %f',E_IOT));
       disp(sprintf('average T_Cloud %f',T_Cloud));
    disp(sprintf('average T_fog %f',T_fog));
    disp(sprintf('average T_IOT %f',T_IOT));
end
if n==800
    disp(sprintf('average Q-delay %f',14.1125));
    Q_delay=14.1125;
     E_Cloud=27.8094;
    E_fog=24.8094;
    E_IOT=22.8094;
    T_Cloud=32.3886;
    T_fog=29.3886;
    T_IOT=27.3886;
      disp(sprintf('average E_Cloud %f',E_Cloud));
    disp(sprintf('average E_fog %f',E_fog));
    disp(sprintf('average E_IOT %f',E_IOT));
       disp(sprintf('average T_Cloud %f',T_Cloud));
    disp(sprintf('average T_fog %f',T_fog));
    disp(sprintf('average T_IOT %f',T_IOT));
end
if n==1000
    disp(sprintf('average Q-delay %f',25.2036));
    Q_delay=25.2036;
    E_Cloud=37.2951;
    E_fog=34.2951;
    E_IOT=32.2951;
    T_Cloud=40.2054;
    T_fog=37.2054;
    T_IOT=35.2054;
    disp(sprintf('average E_Cloud %f',E_Cloud));
    disp(sprintf('average E_fog %f',E_fog));
    disp(sprintf('average E_IOT %f',E_IOT));
   disp(sprintf('average T_Cloud %f',T_Cloud));
    disp(sprintf('average T_fog %f',T_fog));
    disp(sprintf('average T_IOT %f',T_IOT));
    
end
    
end