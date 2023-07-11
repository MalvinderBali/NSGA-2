[T,z,E_off,Q_delay]=result_one(x(24,:));
figure;

bar([1,2,3],sort([sum(sum(T(:,P))),sum(sum(T(:,R))),sum(sum(T(:,S)))]));
xticklabels({'IOT Devices','Edge Devices','Cloud Devices'});
title('Delay');
grid on;
figure;
bar((sort([sum(E_off(1,1:5)),sum(E_off(1,6:8)) sum(E_off(1,9:10))])));
xticklabels({'IOT Devices','Edge Devices','Cloud Devices'});
title('Energy');
grid on;
figure;
bar(sum(Q_delay))