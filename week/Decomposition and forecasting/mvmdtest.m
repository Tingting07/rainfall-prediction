%% 
load origin_data.mat
fs=1;               
Ts=1/fs;             
L=length(X);         
t=(0:L-1)*Ts;        
%% 
alpha = 2000;       % moderate bandwidth constraint
tau = 0;          % noise-tolerance (no strict fidelity enforcement)
K = 8;             % modes
DC = 0;             % no DC part imposed
init = 1;           % initialize omegas uniformly 
tol = 1e-10;        
%--------------- Run actual mVMD code---------------------------
[u, u_hat, omega] = MVMD(X(:,end), alpha, tau, K, DC, init, tol); 
save mvmd_data u
a = K;
figure;
imfn=u;
subplot(a+1,1,1); 
plot(t,X(:,end)); 
title('MVMD')
ylabel('original signal','fontsize',12,'fontname','Times New Roman');
for n1=1:a
    subplot(a+1,1,n1+1);
    plot(t,u(n1,:));
    ylabel(['IMF' int2str(n1)]);
end
 xlabel('time\itt/s','fontsize',12,'fontname','Times New Roman');
 set(gcf, 'Position', [1100 100 260 620]);