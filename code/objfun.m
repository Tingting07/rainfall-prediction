function fitness=objfun(para,signal,lb,ub,criterion)
% criterion 用以选择目标函数
% 边界检查，防止超出 变量范围
Flag4ub=para>ub;
Flag4lb=para<lb;
para=(para.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;

%% VMD分解
tau=0;%两处vmd函数用到此参数
DC=0;%两处vmd函数用到此参数
init=1;%两处vmd函数用到此参数
tol=1e-7;%是1x10的-7次方,两处vmd函数用到此参数
alpha = round(para(1));
k = round(para(2));
% 调用VMD
[imf, ~, omega] = VMD(signal , alpha, tau,  round(k), DC, init, tol); 
%% 选择目标函数
 criterion = 2
    for i=1:k
        amp=histcounts(imf(i,:));
        amp_n = amp/sum(amp);
        feature(i) = -sum(amp_n.*log(amp_n));  % 计算信息熵
    end
    fitness = min(feature); % 适应度函数值，目的就是使该值最小
    
