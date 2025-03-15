clear
clc
X = xlsread('1968-2021(1).xlsx');
save origin_data X
fs=1;                
Ts=1/fs;            
L=length(X);         
t=(0:L-1)*Ts;       
STA=0;               
Nstd = 0.5;
NR = 500;
MaxIter = 5000;
[uemd its]=eemd(X(:,end),Nstd ,NR,MaxIter);
save eemd_data uemd
% [a b]=size(u);
a = 10;
figure(1);
imfn=uemd;
subplot(a+2,1,1); 
plot(t,X(:,end)); 
ylabel('original signal','fontsize');
for n1=1:a
    subplot(a+1,1,n1+1);
    plot(t,uemd(n1,:));
    ylabel(['IMF' int2str(n1)]);
end
 xlabel('time\itt/s','fontsize');
