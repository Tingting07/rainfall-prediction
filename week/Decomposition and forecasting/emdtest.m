%% EMD
load origin_data.mat
fs=1;                
Ts=1/fs;             
L=length(X);         
t=(0:L-1)*Ts;        
[uemd its]=emd(X(:,end));
save emd_data uemd
[a b]=size(uemd);
figure;
imfn=uemd;
subplot(a+1,1,1); 
plot(t,X(:,end)); 
ylabel('original signal','fontsize',12,'fontname','Times New Roman');
title('EMD')
for n1=1:a
    subplot(a+1,1,n1+1);
    plot(t,uemd(n1,:));
    ylabel(['IMF' int2str(n1)]);
end
xlabel('time\itt/s');
set(gcf, 'Position', [100 100 260 620]); 