%% CEEMDAN
clc,clear all
load origin_data.mat
fs=1;                
Ts=1/fs;             
L=length(X);         
t=(0:L-1)*Ts;        
Nstd = 0.2;
NR = 500;
MaxIter = 5000;
[uceemdan its]=ceemdan(X(:,end),Nstd,NR,MaxIter);
uceemdan = uceemdan'
save ceemdan_data uceemdan
[a b]=size(uceemdan);
figure;
imfn=uceemdan;
load('origin_data.mat');  % 假设文件中包含变量 data1
load('ceemdan_data.mat');
combined_data = [X,uceemdan];