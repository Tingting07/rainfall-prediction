%% MVMD
clc,clear all
load origin_data.mat
fs=1;                
Ts=1/fs;             
L=length(X);         
t=(0:L-1)*Ts;        
alpha = 2000;       % moderate bandwidth constraint
tau = 0;          % noise-tolerance (no strict fidelity enforcement)
K = 8;             % modes
DC = 0;             % no DC part imposed
init = 1;           % initialize omegas uniformly 
tol = 1e-10;        
%--------------- Run actual MVMD code---------------------------
[u, u_hat, omega] = MVMD(X, alpha, tau, K, DC, init, tol);
save mvmd_data u
a = K;
imfn=u;