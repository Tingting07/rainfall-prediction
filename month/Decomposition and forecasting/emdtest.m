%% 
clc,clear all
load origin_data.mat
fs=1;               
Ts=1/fs;             
L=length(X);         
t=(0:L-1)*Ts;        
[uemd its]=emd(X(:,end));
save emd_data uemd
[a b]=size(uemd);
imfn=uemd;