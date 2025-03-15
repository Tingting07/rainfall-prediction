function fitness=objfun(para,signal,lb,ub,criterion)
Flag4ub=para>ub;
Flag4lb=para<lb;
para=(para.*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;

tau=0;%
DC=0;%
init=1;
tol=1e-7;
alpha = round(para(1));
k = round(para(2));
%
[imf, ~, omega] = VMD(signal , alpha, tau,  round(k), DC, init, tol); 
%% 
switch criterion
    %% 
    case 1
        for i = 1:k
            amp= abs(hilbert(imf(i,:))); 
            amp_n = amp/sum(amp);
            feature(i) = -sum(amp_n.*log(amp_n));  
        end
        fitness = min(feature); 
        
        
    case 2
        for i=1:k
            amp=histcounts(imf(i,:));
            amp_n = amp/sum(amp);
            feature(i) = -sum(amp_n.*log(amp_n));  
        end
        fitness = min(feature);
     
    case 3
        emb=4;
        delay =1;
        for i=1:k
            feature(i)=PermutationEntropy(imf(i,:), emb, delay);
        end
        fitness=min(feature);
        
end