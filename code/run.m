%% 优化VMD
clc;clear;close all
warning off
%% 加载数据
X = xlsread('1968-2021(1).xlsx');
save origin_data X
data = X(:,end);
signal=data;
%% 设定必要参数

tau=0;%两处vmd函数用到此参数
DC=0;%两处vmd函数用到此参数
init=1;%两处vmd函数用到此参数
tol=1e-7;%是1x10的-7次方,两处vmd函数用到此参数
%% 2. 优化方法参数设置
lb=[100, 2];% 变量下限
ub=[5000, 20];% 变量上限
dim = length(lb);% 优化参数个数为2
Max_iter = 30; %最大迭代次数
sizepop = 10; %种群规模
criterion = 2;
fobj=@(x) objfun(x,signal,lb,ub,criterion); % 调用定义的目标函数
%% 调用优化算法进行参数寻优
tic
%algor_name='GWO'; % 算法名字
%[bestfitness,bestx,Convergence_curve]=GWO(sizepop,Max_iter,lb,ub,dim,fobj);
%algor_name='CPO'; % 算法名字
[bestfitness,bestx,Convergence_curve]=CPO(sizepop,Max_iter,lb,ub,dim,fobj);
%algor_name='HHO'; % 算法名字
%[bestfitness,bestx,Convergence_curve]=HHO(sizepop,Max_iter,lb,ub,dim,fobj);
%algor_name='PSO'; % 算法名字
%[bestfitness,bestx,Convergence_curve]=PSO(sizepop,Max_iter,lb,ub,dim,fobj);
toc % 优化的时间

%% VMD的优化后的参数
bestg = round(bestx(1)); % （优化算法优化后的）
bestc = round(bestx(2));% （优化算法优化后的）
% 带入VMD，进行分解
tic
fs=1;                % 采样频率，即时间序列两个数据之间的时间间隔
Ts=1/fs;             % 采样周期
L=length(X);         % 采样点数,即有多少个数据
t=(0:L-1)*Ts;        % 时间序列
alpha=bestg;
K=round(bestc);%将 bestc 的每个元素四舍五入为最近的整数。
[u, ~, omega] = VMD(signal,bestg, tau,round(bestc), DC, init, tol);   
save vmd_data u
%% 画出分解图
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
% 绘制残差
subplot(n+2,1,n+2);
plot(t, signal' - reconstructed_signal); % 绘制残差
ylabel('残差');
xlabel('数据序列','fontsize',12,'fontname','宋体');
