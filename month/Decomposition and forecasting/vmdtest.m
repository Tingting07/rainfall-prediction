tic     
clc
clear all
fs=1;              
Ts=1/fs;            
load origin_data.mat

L=length(X);         
t=(0:L-1)*Ts;        
STA=0;               
U = X(:,end);
%--------- some sample parameters forVMD£º---------------
alpha = 2286;       % moderate bandwidth constraint
tau = 0;          % noise-tolerance (no strict fidelity enforcement)
K = 18;              % modes
DC = 0;             % no DC part imposed
init = 1;           % initialize omegas uniformly
tol = 1e-7         
%--------------- Run actual VMD code---------------------------
[u, u_hat3, omega] = VMD(U, alpha, tau, K, DC, init, tol);

save vmd_data u

figure;
imfn=u;
n=size(imfn,1); 
subplot(n+2,1,1);  
plot(t,X(:,end)); 
ylabel('original signal','fontsize',12);
title('VMD Decomposition');

reconstructed_signal = sum(imfn, 1);
for n1=1:n
    subplot(n+2,1,n1+1);
    plot(t,u(n1,:));
    ylabel(['IMF' int2str(n1)]);
end
xlabel('time\itt/hour','fontsize',12);
res = X(:,end)' - reconstructed_signal;
subplot(n+2,1,n+2);
plot(t, res); 
ylabel('residual');
xlabel('data series','fontsize',12);
ytick_positions = [1, (1:n)+1, n+2];  
ytick_labels = {'original signal'}; 
for n1 = 1:n
    ytick_labels{end+1} = ['IMF' num2str(n1)]; 
end
ytick_labels{end+1} = 'residual';  

