clc;
clear all;
%%
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
global Wa;     % weighting Que time
global f_CPU_cloud;
global lamda;

%%
P=5; % number of sensing devices
global n;
R=3; % edge devices
Q=3; % gate way devices;
S=2;  % cloud servers
n=100; %number of tasks
V=P+R+S; %Total number of processing devices
CPU_requirement_LB=10;
CPU_requirement_UB=100;
arraival_frequency_LB=1;
arraival_frequency_UB=10;
deadline_bound_LB=1;
deadline_bound_UB=5;
data_size_LB=10;
data_size_UB=100;
uploading_BW_LB=10000;
uploading_BW_UB=20000;
transmition_power_LB=10;
transmition_power_UB=100;
 OED=rand(1,n); %Execution dead line
 Afreq=rand(1,n); %arrival frequency
 U=OED./ Afreq;%utilization factor
%formation of independent task tupple
n1=3;     %n1 denotes the number of preceding tasks
n2=4;      %n2 represents the total number of preceding tasks waiting in QC
n3=5;      %n3 represents the total number of preceding taskswaiting in QN.
Wa=0.001;  % weighting Que time
f_CPU_cloud=rand(1,n).*10000;
lamda=rand(1,n); %arrival_rates