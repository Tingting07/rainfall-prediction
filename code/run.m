%% �Ż�VMD
clc;clear;close all
warning off
%% ��������
X = xlsread('1968-2021(1).xlsx');
save origin_data X
data = X(:,end);
signal=data;
%% �趨��Ҫ����

tau=0;%����vmd�����õ��˲���
DC=0;%����vmd�����õ��˲���
init=1;%����vmd�����õ��˲���
tol=1e-7;%��1x10��-7�η�,����vmd�����õ��˲���
%% 2. �Ż�������������
lb=[100, 2];% ��������
ub=[5000, 20];% ��������
dim = length(lb);% �Ż���������Ϊ2
Max_iter = 30; %����������
sizepop = 10; %��Ⱥ��ģ
criterion = 2;
fobj=@(x) objfun(x,signal,lb,ub,criterion); % ���ö����Ŀ�꺯��
%% �����Ż��㷨���в���Ѱ��
tic
%algor_name='GWO'; % �㷨����
%[bestfitness,bestx,Convergence_curve]=GWO(sizepop,Max_iter,lb,ub,dim,fobj);
%algor_name='CPO'; % �㷨����
[bestfitness,bestx,Convergence_curve]=CPO(sizepop,Max_iter,lb,ub,dim,fobj);
%algor_name='HHO'; % �㷨����
%[bestfitness,bestx,Convergence_curve]=HHO(sizepop,Max_iter,lb,ub,dim,fobj);
%algor_name='PSO'; % �㷨����
%[bestfitness,bestx,Convergence_curve]=PSO(sizepop,Max_iter,lb,ub,dim,fobj);
toc % �Ż���ʱ��

%% VMD���Ż���Ĳ���
bestg = round(bestx(1)); % ���Ż��㷨�Ż���ģ�
bestc = round(bestx(2));% ���Ż��㷨�Ż���ģ�
% ����VMD�����зֽ�
tic
fs=1;                % ����Ƶ�ʣ���ʱ��������������֮���ʱ����
Ts=1/fs;             % ��������
L=length(X);         % ��������,���ж��ٸ�����
t=(0:L-1)*Ts;        % ʱ������
alpha=bestg;
K=round(bestc);%�� bestc ��ÿ��Ԫ����������Ϊ�����������
[u, ~, omega] = VMD(signal,bestg, tau,round(bestc), DC, init, tol);   
save vmd_data u
%% �����ֽ�ͼ
figure;
imfn=u;
n=size(imfn,1); %size(X,1),���ؾ���X��������size(X,2),���ؾ���X��������N=size(X,2)�����ǰѾ���X��������ֵ��N
subplot(n+2,1,1);  % m�����У�n�����У�p��������ͼ�λ��ڵڼ��С��ڼ��С�����subplot(2,2,[1,2])
plot(t,X(:,end)); 
ylabel('ԭʼ�ź�','fontsize',12,'fontname','����');
title('VMD�ֽ�');
% �����ع��ź�
reconstructed_signal = sum(imfn, 1);
for n1=1:n
    subplot(n+2,1,n1+1);
    plot(t,u(n1,:));%���IMF������a(:,n)���ʾ����a�ĵ�n��Ԫ�أ�u(n1,:)��ʾ����u��n1��Ԫ��
    ylabel(['IMF' int2str(n1)]);%int2str(i)�ǽ���ֵi���������ת����ַ���y������
end
% ���Ʋв�
subplot(n+2,1,n+2);
plot(t, signal' - reconstructed_signal); % ���Ʋв�
ylabel('�в�');
xlabel('��������','fontsize',12,'fontname','����');
