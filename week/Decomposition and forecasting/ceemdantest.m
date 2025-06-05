clc,clear all
load origin_data.mat
fs=1;               
Ts=1/fs;             
L=length(X);         
t=(0:L-1)*Ts;        
STA=0;               
Nstd = 0.5;
NR = 500;
MaxIter = 5000;
[modes its]=ceemdan(X(:,end),Nstd,NR,MaxIter);
save ceemdan_data modes
t=1:length(X(:,end));

[a b]=size(modes);

figure;
subplot(a+1,1,1);
plot(t,X(:,end));% the ECG signal is in the first row of the subplot
ylabel('ceemdan')
set(gca,'xtick',[])
axis tight;

for i=2:a
    subplot(a+1,1,i);
    plot(t,modes(i-1,:));
    ylabel (['IMF ' num2str(i-1)]);
    set(gca,'xtick',[])
    xlim([1 length(X(:,end))])
end;

subplot(a+1,1,a+1)
plot(t,modes(a,:))
ylabel(['IMF ' num2str(a)])
xlim([1 length(X(:,end))])

figure;
boxplot(its);