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
save ceemdan_data uceemdan
[a b]=size(uceemdan);
figure;
imfn=uceemdan;
for n1=1:a
    subplot(a+1,1,n1+1);
    plot(t,uceemdan(n1,:));
    ylabel(['IMF' int2str(n1)]);
end
set(gcf, 'Position', [500 100 260 620]); 