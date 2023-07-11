clear, clc;
close all;
%%
clc;
clear all;
%%
tic
global P; % number of sensing devices
global n;
global R; % fog devices
global Q; % gate way devices;
global S;  % cloud servers
global n; %number of tasks
% V=P+R+S; %Total number of processing devices
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
global n4;
global Wa;     % weighting Queue time
global f_CPU_cloud;
global lamda;

%%
P=200; % number of sensing devices
global n;
R=20; % edge devices
Q=3; % gate way devices;
S=2;  % cloud servers
n=250; %number of tasks
V=P+R+S; %Total number of processing devices
CPU_requirement_LB=0.1;
CPU_requirement_UB=0.5;
arraival_frequency_LB=1;
arraival_frequency_UB=10;
deadline_bound_LB=0;
deadline_bound_UB=10;
data_size_LB=0;
data_size_UB=10;
uploading_BW_LB=10000;
uploading_BW_UB=20000;
transmition_power_LB=1;
transmition_power_UB=1.2;
 OED=0+10.*rand(1,n); %Execution dead line[0 10]
 Afreq=1+8.*rand(1,n); %arrival frequency [1 9]
 U=OED./ Afreq;%utilization factor
%formation of independent task tupple
n1=3;     %n1 denotes the number of preceding tasks
n2=4;      %n2 represents the total number of preceding tasks waiting in QC
n3=5;      %n3 represents the total number of preceding taskswaiting in QN.
n4=2;
Wa=1e-6;  % weighting Queue time
f_CPU_cloud=rand(1,n).*1e9;
lamda=randi([1,9],1,n).*0.1; %arrival_rates
%%
%problem formulation
objective =@(x) objective(x);
nv=(n*(R+S));

min=-1;
max=1;


%NSGA parameters
Max_iter=50;
np=50;
pc=0.7;
nc=round(np*pc/2);
pm=0.2;
nm=round(np*pm);
mu=0.02;
sigma=0.1;

%initialization
empty.crowdingdistance=[];
empty.rank=[];
empty.dominationset=[];
empty.dominationcount=[];

population= repmat(empty,np,1);
a=repmat(min,np,nv);
b=repmat(max,np,nv);
x=a+(rand(np,nv)).*(b-a);
for po=1:np
z(po,:)=objective(x(po,:));
end
%%
% non dominated sorting
[population, F]=nondominatedsorting(population,z);
%crowding distance
population=crowding_distance_calculation(z,F,population);

%% sort the population 
[population,z,x,F]=sortpopulation(population,z,x);

%%
% Main loop 
for it=1:Max_iter
    % cross over operation
    
    popc= repmat(empty, 2*nc, 1);
    yl =zeros(nc,nv);
    y2 = zeros(nc,nv);
%     zrcossyl = zeros(nc,nv); 
%     zrcossy2 = zeros(nc,nv);
    
    for k=1:nc
        i1= randi(np);
        p1=x(i1,:);
        ipk = 1;
        while ipk < (ipk + 1)
            i2 =randi(np); 
            if i2~=i1
                break;
            end
            ipk=ipk+1; 
        end
        p2=x(i2,:);
        
        [y1(k,:),y2(k,:)]=crossover(p1,p2,nv,min,max);
        zrcossyl(k,:)=objective(y1(k,:));
        zrcossy2(k,:)=objective(y2(k,:));
        
    end
    zcross=[zrcossyl;zrcossy2];
    ycross=[y1;y2];
    
    % mutatin process
    popm = repmat(empty,nm,1);
    ym=zeros(nm,nv);
%     zmutate=zeros(nm,nv);
    
    for k=1:nm
        i=randi(np);
        p=x(i,:);
        
        
        ym(k,:)=mutation (p,nv,sigma,min,max);
        
        zmutate(k,:)=objective(ym(k,:));
    end
    
    % merge solution
    population_merge=[population
                      popc
                      popm];
                  
    z_merge =[z
              zcross
              zmutate];
     
    x_merge= [x
              ycross
              ym];
          
    % non dominated sorting
    [population_nds, F_nds]=nondominatedsorting(population_merge,z_merge);
 
    %ccrowding distance calculation
    [population_cds]=crowding_distance_calculation(z_merge,F_nds,population_nds);
 
    % sort the population
    [population_sp,zs,xs,Fs]=sortpopulation(population_cds,z_merge,x_merge);
    
    % survival selection
    population=population_sp(1:np);
    z=zs(1:np,:);
    x=xs(1:np,:);
    
    % non dominated sorting
    [population, F]=nondominatedsorting(population,z);
 
    %crowding distance calculation
    [population]=crowding_distance_calculation(z,F,population);
 
    % sort the population
    [population,z,x,F]=sortpopulation(population,z,x);
 
    % plot this
 
    figure(1);
 
    plot(z(:,1),z(:,2),'*')
 
    xlabel('Energy(J)')
    ylabel('Time Delay(sec)')
 
    title('NSGA II')
    grid on
end
toc
plotting_one;