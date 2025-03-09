tic     % 测试代码执行所需要的时间
clc
clear all
fs=1;                % 采样频率，即时间序列两个数据之间的时间间隔
Ts=1/fs;             % 采样周期
X = xlsread('1968-2021(1).xlsx');
save origin_data X

L=length(X);         % 采样点数,即有多少个数据
t=(0:L-1)*Ts;        % 时间序列
STA=0;               % 采样起始位置，这里第0h开始采样
U = X(:,end);
%--------- some sample parameters forVMD：对于VMD样品参数进行设置---------------
alpha = 2286;       % moderate bandwidth constraint：适度的带宽约束/惩罚因子
tau = 0;          % noise-tolerance (no strict fidelity enforcement)：噪声容限（没有严格的保真度执行）
K = 18;              % modes：分解的模态数
DC = 0;             % no DC part imposed：无直流部分
init = 1;           % initialize omegas uniformly  ：omegas的均匀初始化
tol = 1e-7         
%--------------- Run actual VMD code:数据进行vmd分解---------------------------
%% 对月降雨量进行分解
[u, u_hat3, omega] = VMD(U, alpha, tau, K, DC, init, tol);

save vmd_data u

figure;
imfn=u;
n=size(imfn,1); %size(X,1),返回矩阵X的行数；size(X,2),返回矩阵X的列数；N=size(X,2)，就是把矩阵X的列数赋值给N
subplot(n+2,1,1);  % m代表行，n代表列，p代表的这个图形画在第几行、第几列。例如subplot(2,2,[1,2])
plot(t,X(:,end)); 
ylabel('原始信号','fontsize',12,'fontname','宋体');
title('VMD分解');
% 计算重构信号
reconstructed_signal = sum(imfn, 1);
for n1=1:n
    subplot(n+2,1,n1+1);
    plot(t,u(n1,:));%输出IMF分量，a(:,n)则表示矩阵a的第n列元素，u(n1,:)表示矩阵u的n1行元素
    ylabel(['IMF' int2str(n1)]);%int2str(i)是将数值i四舍五入后转变成字符，y轴命名
end
xlabel('时间\itt/hour','fontsize',12,'fontname','宋体');
% 绘制残差
res = X(:,end)' - reconstructed_signal;
subplot(n+2,1,n+2);
plot(t, res); % 绘制残差
ylabel('残差');
xlabel('数据序列','fontsize',12,'fontname','宋体');
%% 计算 y 轴的刻度位置和标签
ytick_positions = [1, (1:n)+1, n+2];  % 设置 y 轴的刻度位置
ytick_labels = {'原始信号'};  % 设置 y 轴的刻度标签
for n1 = 1:n
    ytick_labels{end+1} = ['IMF' num2str(n1)];  % 添加每个 IMF 分量的标签
end
ytick_labels{end+1} = '残差';  % 添加残差的标签

