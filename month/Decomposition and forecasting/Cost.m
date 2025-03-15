function ff = Cost(c)
X = xlsread('1968-2021(1).xlsx');
data = X(:,end);
signal=data;%两处vmd函数用到此参数，此参数为一个信号，从表中读取的参数
alpha = round(c(1));       % moderate bandwidth constraint：适度的带宽约束/惩罚因子
tau = 0;          % noise-tolerance (no strict fidelity enforcement)：噪声容限（没有严格的保真度执行）
K = round(c(2));              % modes：分解的模态数
DC = 0;             % no DC part imposed：无直流部分
init = 1;           % initialize omegas uniformly  ：omegas的均匀初始化
tol = 1e-7;     
%--------------- Run actual VMD code:数据进行vmd分解---------------------------
[u, u_hat, omega] = VMD(signal, alpha, tau, K, DC, init, tol);
%% 计算最小包络熵
for i = 1:K
	xx= abs(hilbert(u(i,:))); %首先对分解得到的IMF分量进行希尔伯特变换，并求取幅值
	xxx = xx/sum(xx); %
    ssum=0;
    for ii = 1:size(xxx,2)
		bb = -xxx(1,ii)*log(xxx(1,ii));
        ssum=ssum+bb;
    end
    fitness(i,:) = ssum;
end
ff = min(fitness);
end
% figure
% plot(u(5,:))
% hold on
% plot(xx)

% fs=1;%采样频率
% Ts=1/fs;%采样周期
% L=2048;%采样点数
% t=(0:L-1)*Ts;%时间序列
% STA=1; %采样起始位置
% figure(1);
% imfn=u;
% n=size(imfn,1); %size(X,1),返回矩阵X的行数；size(X,2),返回矩阵X的列数；N=size(X,2)，就是把矩阵X的列数赋值给N
% subplot(n+1,1,1);  % m代表行，n代表列，p代表的这个图形画在第几行、第几列。例如subplot(2,2,[1,2])
% plot(t,X); %故障信号
% ylabel('原始信号','fontsize',12,'fontname','宋体');
% 
% for n1=1:n
%     subplot(n+1,1,n1+1);
%     plot(t,u(n1,:));%输出IMF分量，a(:,n)则表示矩阵a的第n列元素，u(n1,:)表示矩阵u的n1行元素
%     ylabel(['IMF' int2str(n1)]);%int2str(i)是将数值i四舍五入后转变成字符，y轴命名
% end
%  xlabel('时间\itt/s','fontsize',12,'fontname','宋体');
% 	
% nfft=12000;  
% p=abs(fft(imfn(2,:),nfft)); %将x3补齐到1024个，并fft，得到p，就是包络线的fft---包络谱
% figure
% plot((0:nfft-1)/nfft*fs,p)   %绘制包络谱
% title('包络谱')
