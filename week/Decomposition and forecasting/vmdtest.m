tic     
clc
clear all
fs=1;                
Ts=1/fs;             
%% 
load origin_data.mat
L=length(X);         
t=(0:L-1)*Ts;       
STA=0;              

%--------- some sample parameters forVMD---------------
alpha = 100;       % moderate bandwidth constraint
tau = 0;          % noise-tolerance (no strict fidelity enforcement)
K = 5;              % modes
DC = 0;             % no DC part imposed
init = 1;           % initialize omegas uniformly  
tol = 1e-7         
%--------------- Run actual VMD code---------------------------
%%
[u, u_hat3, omega] = VMD(X(:,end), alpha, tau, K, DC, init, tol);

save vmd_data u

figure;
imfn=u;
n=size(imfn,1); 
subplot(n+2,1,1);  
plot(t,X(:,end)); 
ylabel('original signal','fontsize',12,'fontname','Times New Roman');
title('VMD Decomposition');

reconstructed_signal = sum(imfn, 1);
for n1=1:n
    subplot(n+2,1,n1+1);
    plot(t,u(n1,:));
    ylabel(['IMF' int2str(n1)]);
end
xlabel('time\itt/hour','fontsize',12,'fontname','Times New Roman');

res = X(:,end)' - reconstructed_signal;
subplot(n+2,1,n+2);
plot(t, res); 
ylabel('residual');
xlabel('data series','fontsize',12,'fontname','Times New Roman');

