load origin_data.mat
fs=1;                
Ts=1/fs;             
L=length(X);         
t=(0:L-1)*Ts;        
STA=0;               
Nstd = 0.5;
NR = 500;
MaxIter = 5000;
Nstd = 0.4;
NE = 200; % # of ensemble
numImf = 8; % # of imfs
tic;
[ufeemd] = feemd(X(:,end),Nstd,NE,numImf); 
save feemd_data ufeemd
toc;
%imf = imf';

figure;  
nimf = size(imf,1); 
for (m=1:nimf)
    subplot(nimf,1,m); plot(t,imf(m,:),'k','LineWIdth',1.5);
end
subplot(nimf,1,1); title('IMFs');

