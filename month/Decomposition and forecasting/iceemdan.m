%Function for CEEMDAN

%WARNING: for this code works it is necessary to include in the same
%directoy the file emd.m developed by Rilling and Flandrin.
%This file is available at %http://perso.ens-lyon.fr/patrick.flandrin/emd.html
%We use the default stopping criterion.
%We use the last modification: 3.2007

%   Syntax

%modes=ceemdan(x,Nstd,NR,MaxIter,SNRFlag)
%[modes its]=ceemdan(x,Nstd,NR,MaxIter,SNRFlag)

%   Description

%OUTPUT
%modes: contain the obtained modes in a matrix with the rows being the modes        
%its: contain the sifting iterations needed for each mode for each realization (one row for each realization)

%INPUT
%x: signal to decompose
%Nstd: noise standard deviation
%NR: number of realizations
%MaxIter: maximum number of sifting iterations allowed.
%SNRFlag: if equals 1, then the SNR increases for every stage, as in [1].
%           If equals 2, then the SNR is the same for all stages, as in [2]. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The current is an improved version, introduced in:

%[1] Colominas MA, Schlotthauer G, Torres ME. "Improve complete ensemble EMD: A suitable tool for biomedical signal processing" 
%       Biomedical Signal Processing and Control vol. 14 pp. 19-29 (2014)

%The CEEMDAN algorithm was first introduced at ICASSP 2011, Prague, Czech Republic

%The authors will be thankful if the users of this code reference the work
%where the algorithm was first presented:

%[2] Torres ME, Colominas MA, Schlotthauer G, Flandrin P. "A Complete Ensemble Empirical Mode Decomposition with Adaptive Noise"
%       Proc. 36th Int. Conf. on Acoustics, Speech and Signa Processing ICASSP 2011 (May 22-27, Prague, Czech Republic)

%Author: Marcelo A. Colominas
%contact: macolominas@bioingenieria.edu.ar
%Last version: 25 feb 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [modes,its]=iceemdan(x,Nstd,NR,MaxIter,SNRFlag)   % x是输入信号，代表被分解的时间序列数据；Nstd：添加到信号中的白噪声的标准差，控制噪声的幅度
%NR：信号与不同噪声实现一起处理的次数；MaxIter：最大迭代次数；SNRFlag：在分解过程中是否考虑信噪比
%modes：一个矩阵或数组，包含分解得到的IMFs,矩阵的每一列代表一个IMF
%its:
x=x(:)';   
desvio_x=std(x);  %std计算标准差的函数,数据点与数据集平均值的偏差
x=x/desvio_x;     %将x中的数据标准化，使得新的数据集的均值为0，标准差为1

modes=zeros(size(x));             %创建一个与x同样尺寸的矩阵，并将其所有元素初始化为0
temp=zeros(size(x));              %存储分解过程中的临时数据
aux=zeros(size(x));               %辅助计算，作为工作空间来存储某些中间状态
iter=zeros(NR,round(log2(length(x))+5)); %iter与迭代过程相关的信息
%创建了一个与输入信号x同样大小的白噪声矩阵
for i=1:NR                        %白噪声实现的数量
    white_noise{i}=randn(size(x));%生成白噪声实现
end;
%对每一组白噪声实例进行EMD分解。获取内在模态函数，创建模态集合
for i=1:NR
    modes_white_noise{i}=emd(white_noise{i});%calculates the modes of white gaussian noise
end;
%计算原始信号x的第一个模态（IMF）
for i=1:NR %calculates the first mode
    xi=x+Nstd*modes_white_noise{i}(1,:)/std(modes_white_noise{i}(1,:));
    [temp, o, it]=emd(xi,'MAXMODES',1,'MAXITERATIONS',MaxIter); %temp是分解得到的模态，o是剩余信号，it是迭代次数
    temp=temp(1,:); %将temp的第一个IMF赋值给temp，只取第一列
    aux=aux+(xi-temp)/NR;
    iter(i,1)=it;
end;

modes= x-aux; %saves the first mode
medias = aux;
k=1;
aux=zeros(size(x));
es_imf = min(size(emd(medias(end,:),'MAXMODES',1,'MAXITERATIONS',MaxIter)));

while es_imf>1 %calculates the rest of the modes
    for i=1:NR
        tamanio=size(modes_white_noise{i});
        if tamanio(1)>=k+1   %检查当前噪声实现是否有足够的模态来提取
            noise=modes_white_noise{i}(k+1,:);  %提取第k+1个模态的噪声部分
            if SNRFlag == 2
                noise=noise/std(noise); %adjust the std of the noise
            end;
            noise=Nstd*noise;
            try
                [temp,o,it]=emd(medias(end,:)+std(medias(end,:))*noise,'MAXMODES',1,'MAXITERATIONS',MaxIter);
            catch    
                it=0; disp('catch 1 '); disp(num2str(k))
                temp=emd(medias(end,:)+std(medias(end,:))*noise,'MAXMODES',1,'MAXITERATIONS',MaxIter);
            end;
            temp=temp(end,:);
        else
            try
                [temp, o, it]=emd(medias(end,:),'MAXMODES',1,'MAXITERATIONS',MaxIter);
            catch
                temp=emd(medias(end,:),'MAXMODES',1,'MAXITERATIONS',MaxIter);
                it=0; disp('catch 2 sin ruido')
            end;
            temp=temp(end,:);
        end;
        aux=aux+temp/NR;
    iter(i,k+1)=it;    
    end;
    modes=[modes;medias(end,:)-aux];
    medias = [medias;aux];
    aux=zeros(size(x));
    k=k+1;
    es_imf = min(size(emd(medias(end,:),'MAXMODES',1,'MAXITERATIONS',MaxIter)));
end;
modes = [modes;medias(end,:)];
modes=modes*desvio_x;
its=iter;