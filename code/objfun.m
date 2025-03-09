function fitness=objfun(para,signal,lb,ub,criterion)
% criterion ����ѡ��Ŀ�꺯��
% �߽��飬��ֹ���� ������Χ
Flag4ub=para>ub;
Flag4lb=para<lb;
para=(para.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;

%% VMD�ֽ�
tau=0;%����vmd�����õ��˲���
DC=0;%����vmd�����õ��˲���
init=1;%����vmd�����õ��˲���
tol=1e-7;%��1x10��-7�η�,����vmd�����õ��˲���
alpha = round(para(1));
k = round(para(2));
% ����VMD
[imf, ~, omega] = VMD(signal , alpha, tau,  round(k), DC, init, tol); 
%% ѡ��Ŀ�꺯��
 criterion = 2
    for i=1:k
        amp=histcounts(imf(i,:));
        amp_n = amp/sum(amp);
        feature(i) = -sum(amp_n.*log(amp_n));  % ������Ϣ��
    end
    fitness = min(feature); % ��Ӧ�Ⱥ���ֵ��Ŀ�ľ���ʹ��ֵ��С
    
