function ff = Cost(c)
X = xlsread('1968-2021(1).xlsx');
data = X(:,end);
signal=data;%����vmd�����õ��˲������˲���Ϊһ���źţ��ӱ��ж�ȡ�Ĳ���
alpha = round(c(1));       % moderate bandwidth constraint���ʶȵĴ���Լ��/�ͷ�����
tau = 0;          % noise-tolerance (no strict fidelity enforcement)���������ޣ�û���ϸ�ı����ִ�У�
K = round(c(2));              % modes���ֽ��ģ̬��
DC = 0;             % no DC part imposed����ֱ������
init = 1;           % initialize omegas uniformly  ��omegas�ľ��ȳ�ʼ��
tol = 1e-7;     
%--------------- Run actual VMD code:���ݽ���vmd�ֽ�---------------------------
[u, u_hat, omega] = VMD(signal, alpha, tau, K, DC, init, tol);
%% ������С������
for i = 1:K
	xx= abs(hilbert(u(i,:))); %���ȶԷֽ�õ���IMF��������ϣ�����ر任������ȡ��ֵ
	xxx = xx/sum(xx); %
    ssum=0;
    for ii = 1:size(xxx,2)
		bb = -xxx(1,ii)*log(xxx(1,ii));
        ssum=ssum+bb;
    end
    fitness(i,:) = ssum;
end
ff = min(fitness);
end
% figure
% plot(u(5,:))
% hold on
% plot(xx)

% fs=1;%����Ƶ��
% Ts=1/fs;%��������
% L=2048;%��������
% t=(0:L-1)*Ts;%ʱ������
% STA=1; %������ʼλ��
% figure(1);
% imfn=u;
% n=size(imfn,1); %size(X,1),���ؾ���X��������size(X,2),���ؾ���X��������N=size(X,2)�����ǰѾ���X��������ֵ��N
% subplot(n+1,1,1);  % m�����У�n�����У�p��������ͼ�λ��ڵڼ��С��ڼ��С�����subplot(2,2,[1,2])
% plot(t,X); %�����ź�
% ylabel('ԭʼ�ź�','fontsize',12,'fontname','����');
% 
% for n1=1:n
%     subplot(n+1,1,n1+1);
%     plot(t,u(n1,:));%���IMF������a(:,n)���ʾ����a�ĵ�n��Ԫ�أ�u(n1,:)��ʾ����u��n1��Ԫ��
%     ylabel(['IMF' int2str(n1)]);%int2str(i)�ǽ���ֵi���������ת����ַ���y������
% end
%  xlabel('ʱ��\itt/s','fontsize',12,'fontname','����');
% 	
% nfft=12000;  
% p=abs(fft(imfn(2,:),nfft)); %��x3���뵽1024������fft���õ�p�����ǰ����ߵ�fft---������
% figure
% plot((0:nfft-1)/nfft*fs,p)   %���ư�����
% title('������')
