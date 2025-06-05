%% ICEEMDAN
load origin_data.mat
fs=1;               
Ts=1/fs;             
L=length(X);        
t=(0:L-1)*Ts;       
Nstd = 0.2;
NR = 500;
MaxIter = 5000;
[uiceemdan,its]=iceemdan(X(:,end),Nstd,NR,MaxIter,1);
save iceemdan_data uiceemdan
[a b]=size(uiceemdan);
figure;
imfn=uiceemdan;
for n1=1:a
    subplot(a,1,n1);
    plot(t,uiceemdan(n1,:));
    ylabel(['IMF' int2str(n1)]);
end
xlabel('time\itt/s');
set(gcf, 'Position', [600 100 260 620]); 