% Harris's hawk optimizer: In this algorithm, Harris' hawks try to catch the rabbit.

% T: maximum iterations, N: populatoin size, CNVG: Convergence curve
% To run HHO: [Rabbit_Energy,Rabbit_Location,CNVG]=HHO(N,T,lb,ub,dim,fobj)

function [Rabbit_Energy,Rabbit_Location,CNVG]=HHO(N,T,lb,ub,dim,fobj)

% disp('HHO is now tackling your problem')

% initialize the location and Energy of the rabbit
Rabbit_Location=zeros(1,dim);
Rabbit_Energy=inf;

%Initialize the locations 
X=initialization(N,dim,ub,lb);

CNVG=zeros(1,T);

t=0; % Loop counter

while t<T
    for i=1:size(X,1)
        % Check boundries
        FU=X(i,:)>ub;FL=X(i,:)<lb;X(i,:)=(X(i,:).*(~(FU+FL)))+ub.*FU+lb.*FL;
        % fitness of locations
        fitness=fobj(X(i,:));
        % Update the location of Rabbit
        if fitness<Rabbit_Energy
            Rabbit_Energy=fitness;
            Rabbit_Location=X(i,:);
        end
    end
    
    E1=2*(1-(t/T)); % factor to show the decreaing energy of rabbit
    % Update the location of Harris' hawks
    for i=1:size(X,1)
        E0=2*rand()-1; %-1<E0<1
        Escaping_Energy=E1*(E0);  % escaping energy of rabbit
        
        if abs(Escaping_Energy)>=1
            %% Exploration:
            % Harris' hawks perch randomly based on 2 strategy:
            
            q=rand();
            rand_Hawk_index = floor(N*rand()+1);
            X_rand = X(rand_Hawk_index, :);
            if q<0.5
                % perch based on other family members
                X(i,:)=X_rand-rand()*abs(X_rand-2*rand()*X(i,:));
            elseif q>=0.5
                % perch on a random tall tree (random site inside group's home range)
                X(i,:)=(Rabbit_Location(1,:)-mean(X))-rand()*((ub-lb)*rand+lb);
            end
            
        elseif abs(Escaping_Energy)<1
            %% Exploitation:
            % Attacking the rabbit using 4 strategies regarding the behavior of the rabbit
            
            %% phase 1: surprise pounce (seven kills)
            % surprise pounce (seven kills): multiple, short rapid dives by different hawks
            
            r=rand(); % probablity of each event
            
            if r>=0.5 && abs(Escaping_Energy)<0.5 % Hard besiege
                X(i,:)=(Rabbit_Location)-Escaping_Energy*abs(Rabbit_Location-X(i,:));
            end
            
            if r>=0.5 && abs(Escaping_Energy)>=0.5  % Soft besiege
                Jump_strength=2*(1-rand()); % random jump strength of the rabbit
                X(i,:)=(Rabbit_Location-X(i,:))-Escaping_Energy*abs(Jump_strength*Rabbit_Location-X(i,:));
            end
            
            %% phase 2: performing team rapid dives (leapfrog movements)
            if r<0.5 && abs(Escaping_Energy)>=0.5, % Soft besiege % rabbit try to escape by many zigzag deceptive motions
                
                Jump_strength=2*(1-rand());
                X1=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-X(i,:));
                FU=X1>ub;FL=X1<lb;X1=(X1.*(~(FU+FL)))+ub.*FU+lb.*FL;
                if fobj(X1)<fobj(X(i,:)) % improved move?
                    X(i,:)=X1;
                else % hawks perform levy-based short rapid dives around the rabbit
                    X2=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-X(i,:))+rand(1,dim).*Levy(dim);
                    FU=X2>ub;FL=X2<lb;X2=(X2.*(~(FU+FL)))+ub.*FU+lb.*FL;
                    if (fobj(X2)<fobj(X(i,:))), % improved move?
                        X(i,:)=X2;
                    end
                end
            end
            
            if r<0.5 && abs(Escaping_Energy)<0.5, % Hard besiege % rabbit try to escape by many zigzag deceptive motions
                % hawks try to decrease their average location with the rabbit
                Jump_strength=2*(1-rand());
                X1=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-mean(X));
                FU=X1>ub;FL=X1<lb;X1=(X1.*(~(FU+FL)))+ub.*FU+lb.*FL;
                
                if fobj(X1)<fobj(X(i,:)) % improved move?
                    X(i,:)=X1;
                else % Perform levy-based short rapid dives around the rabbit
                    X2=Rabbit_Location-Escaping_Energy*abs(Jump_strength*Rabbit_Location-mean(X))+rand(1,dim).*Levy(dim);
                    FU=X2>ub;FL=X2<lb;X2=(X2.*(~(FU+FL)))+ub.*FU+lb.*FL;
                    if (fobj(X2)<fobj(X(i,:))), % improved move?
                        X(i,:)=X2;
                    end
                end
            end
            %%
        end
    end
    t=t+1;
    CNVG(t)=Rabbit_Energy;
%    Print the progress every 100 iterations
%    if mod(t,100)==0
%        display(['At iteration ', num2str(t), ' the best fitness is ', num2str(Rabbit_Energy)]);
%    end
end

end

% ___________________________________
function o=Levy(d)
beta=1.5;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
u=randn(1,d)*sigma;v=randn(1,d);step=u./abs(v).^(1/beta);
o=step;
end

function Positions=initialization(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,2); % numnber of boundaries

% If the boundaries of all variables are equal and user enter a signle
% number for both ub and lb
if Boundary_no==1
    Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
end

% If each variable has a different lb and ub
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
    end
end
end
