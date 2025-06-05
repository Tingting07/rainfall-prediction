 %% parameter optimization
clc;clear;close all
warning off
%% 
load origin_data.mat
data = X(:,end);
signal=data;
%% 
tau=0;
DC=0;
init=1;
tol=1e-7;
%% 
lb=[100, 2];
ub=[5000, 20];
dim = length(lb);
Max_iter = 30; 
sizepop = 10; %
criterion = 2;
fobj=@(x)objfun(x,signal,lb,ub,criterion);
%% Calling optimization algorithms for parameter finding
tic
algor_name='CPO';
[bestfitness,bestx,Convergence_curve]=CPO(sizepop,Max_iter,lb,ub,dim,fobj);
toc

%% Optimized parameters for VMD
bestg = round(bestx(1)); 
bestc = round(bestx(2));
tic
fs=1;                
Ts=1/fs;             
L=length(X);         
t=(0:L-1)*Ts;        
alpha=bestg;
K=round(bestc);
[u, ~, omega] = VMD(signal,bestg, tau,round(bestc), DC, init, tol);   
save vmd_data u