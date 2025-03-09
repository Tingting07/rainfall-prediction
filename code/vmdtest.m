tic     % ���Դ���ִ������Ҫ��ʱ��
clc
clear all
fs=1;                % ����Ƶ�ʣ���ʱ��������������֮���ʱ����
Ts=1/fs;             % ��������
X = xlsread('1968-2021(1).xlsx');
save origin_data X

L=length(X);         % ��������,���ж��ٸ�����
t=(0:L-1)*Ts;        % ʱ������
STA=0;               % ������ʼλ�ã������0h��ʼ����
U = X(:,end);
%--------- some sample parameters forVMD������VMD��Ʒ������������---------------
alpha = 2286;       % moderate bandwidth constraint���ʶȵĴ���Լ��/�ͷ�����
tau = 0;          % noise-tolerance (no strict fidelity enforcement)���������ޣ�û���ϸ�ı����ִ�У�
K = 18;              % modes���ֽ��ģ̬��
DC = 0;             % no DC part imposed����ֱ������
init = 1;           % initialize omegas uniformly  ��omegas�ľ��ȳ�ʼ��
tol = 1e-7         
%--------------- Run actual VMD code:���ݽ���vmd�ֽ�---------------------------
%% ���½��������зֽ�
[u, u_hat3, omega] = VMD(U, alpha, tau, K, DC, init, tol);

save vmd_data u

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
xlabel('ʱ��\itt/hour','fontsize',12,'fontname','����');
% ���Ʋв�
res = X(:,end)' - reconstructed_signal;
subplot(n+2,1,n+2);
plot(t, res); % ���Ʋв�
ylabel('�в�');
xlabel('��������','fontsize',12,'fontname','����');
%% ���� y ��Ŀ̶�λ�úͱ�ǩ
ytick_positions = [1, (1:n)+1, n+2];  % ���� y ��Ŀ̶�λ��
ytick_labels = {'ԭʼ�ź�'};  % ���� y ��Ŀ̶ȱ�ǩ
for n1 = 1:n
    ytick_labels{end+1} = ['IMF' num2str(n1)];  % ���ÿ�� IMF �����ı�ǩ
end
ytick_labels{end+1} = '�в�';  % ��Ӳв�ı�ǩ

