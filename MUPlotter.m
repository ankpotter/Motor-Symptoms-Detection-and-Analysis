load('MUList.mat')
figure;
scatter3(ControlC(:,1),ControlC(:,2),ControlC(:,3));
hold on;
scatter3(PDC(:,1),PDC(:,2),PDC(:,3),'*');
hold on;
scatter3(HDC(:,1),HDC(:,2),HDC(:,3),'+');
hold on;
xlabel('Mean Acc (g) - X');
ylabel('Mean Acc (g) - Y');
zlabel('Mean Acc (g) - Z');
legend('Control Mu','PD Mu','HD Mu');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
scatter3(ControlMUList(:,1),ControlMUList(:,2),ControlMUList(:,3));
hold on;
scatter3(ControlC(:,1),ControlC(:,2),ControlC(:,3),'*');
xlabel('Mean Acc (g) - X');
ylabel('Mean Acc (g) - Y');
zlabel('Mean Acc (g) - Z');
legend('Individual Mean','Cluster Mean');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
scatter3(HDMUList(:,1),HDMUList(:,2),HDMUList(:,3));
hold on;
scatter3(HDC(:,1),HDC(:,2),HDC(:,3),'*');
xlabel('Mean Acc (g) - X');
ylabel('Mean Acc (g) - Y');
zlabel('Mean Acc (g) - Z');
legend('Individual Mean','Cluster Mean');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
scatter3(PDMUList(:,1),PDMUList(:,2),PDMUList(:,3));
hold on;
scatter3(PDC(:,1),PDC(:,2),PDC(:,3),'*');
xlabel('Mean Acc (g) - X');
ylabel('Mean Acc (g) - Y');
zlabel('Mean Acc (g) - Z');
legend('Individual Mean','Cluster Mean');


