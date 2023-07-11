clc;
clear;
% A1=xlsread('Bench_plots','fig5a');
% A2=xlsread('Bench_plots','fig5b');
% A3=xlsread('Bench_plots','fig6a');
% A4=xlsread('Bench_plots','fig6b');
% A5=xlsread('Bench_plots','fig7a');
% A6=xlsread('Bench_plots','fig7b');
load plot_data
%%
% Figure 5(a)
figure
plot(A1(:,1),A1(:,2),'s-b','LineWidth',2)
hold on
plot(A1(:,1),A1(:,3),'s-r','LineWidth',2)
hold on
plot(A1(:,1),A1(:,4),'s-k','LineWidth',2)
hold on;
plot(A1(:,1),A1(:,5),'s-m','LineWidth',2);
grid on
set(gca,'xlim',[0 1200])
set(gca,'ylim',[0 80])
set(gca, 'XTick', [0 200 400 600 800 1000]) 
set(gca, 'YTick', [0 20 40 60 80])
xlabel('Number of tasks')
ylabel('Queueing Delay (in ms)')
legend('Task set with three Queues','Task set with two Queues','Task set with single Queue','Task set with four Queues')
%%
% Figure 5(b)
figure
aa=A2(:,2);
bb=A2(:,3);
cc=A2(:,4);
dd=A2(:,5);
ee=A2(:,6);
for i=1:5
    h(i,:)=[dd(i) ee(i)];
end       
bar(A2(:,1),h)
grid on 
set(gca, 'YTick', [0 20 40])
ylim([0,40])
xlabel('Number of tasks')
ylabel('Average Queueing Delay (in ms)')
legend('EaS(Benchmark)','E2FDO(Proposed)')

%%
% Figure 6(a)
figure
aa1=A3(:,2);
bb1=A3(:,3);
cc1=A3(:,4);

for i=1:5
    j(i,:)=[aa1(i) bb1(i) cc1(i)];
end       
bar(A3(:,1),j)
grid on 
set(gca,'ylim',[0 50])
set(gca, 'YTick', [0 10 20 30 40 50])
xlabel('Number of tasks')
ylabel('Computation Time (in ms)')
legend('Cloud server','Edge devices','IoT devices')

%%
% Figure 6(b)
figure
aa2=A4(:,2);
bb2=A4(:,3);
cc2=A4(:,4);
dd2=A4(:,5);
ee2=A4(:,6);
for i=1:5
    k(i,:)=[dd2(i) ee2(i)];
end       
bar(A4(:,1),k)
grid on 
set(gca, 'YTick', [0 20 40 60])
ylim([0,60])
xlabel('Number of tasks')
ylabel('Computation Time (in ms)')
legend('EaS(Benchmark)','E2FDO(Proposed)')

%%
% Figure 7(a)
figure
aa3=A5(:,2);
bb3=A5(:,3);
cc3=A5(:,4);
for i=1:5
    l(i,:)=[aa3(i) bb3(i) cc3(i)];
end       
bar(A5(:,1),l)
grid on 
set(gca, 'YTick', [0 10 20 30])
ylim([0,30])
xlabel('Number of tasks')
ylabel('Total Energy (in mW)')
legend('Cloud server','Edge devices','IoT devices')

%%
% Figure 7(b)
figure
aa4=A6(:,2);
bb4=A6(:,3);
cc4=A6(:,4);
dd4=A6(:,5);
ee4=A6(:,6);
for i=1:5
    m(i,:)=[dd4(i) ee4(i)];
end       
bar(A6(:,1),m)
grid on 
set(gca, 'YTick', [0 20 40 60 80])
xlabel('Number of tasks')
ylabel('Average Energy (in mW)')
legend('EaS(Benchmark)','E2FDO(Proposed)')