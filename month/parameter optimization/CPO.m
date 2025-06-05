function [Score, Best_pos, CPO_curve] = CPO(Search_Agents, Max_iterations, Lowerbound, Upperbound, dimensions, objective)
% CPO: Crested Porcupine Optimization 

Lowerbound = ones(1, dimensions) .* Lowerbound;
Upperbound = ones(1, dimensions) .* Upperbound;


N_min = 120; 
T = 2; 
alpha = 0.2; 
Tf = 0.8; 

X = initialization(Search_Agents, dimensions, Upperbound, Lowerbound);
fitness = zeros(1, Search_Agents);
CPO_curve = zeros(1, Max_iterations);

for i = 1:Search_Agents
    fitness(i) = objective(X(i,:));
end

[Score, index] = min(fitness);
Best_pos = X(index, :);

Xp = X;

t = 0;
while t < Max_iterations
    r2 = rand;
    for i = 1:Search_Agents
        U1 = rand(1, dimensions) > rand;
        
        if rand < rand 
            if rand < rand 
                rand_index = randi(Search_Agents);
                y = (X(i,:) + X(rand_index,:)) / 2;
                X(i,:) = X(i,:) + (randn) .* abs(2*rand*Best_pos - y);
            else 
                rand_index1 = randi(Search_Agents);
                rand_index2 = randi(Search_Agents);
                y = (X(i,:) + X(rand_index1,:)) / 2;
                X(i,:) = (U1) .* X(i,:) + (1-U1) .* (y + rand*(X(rand_index1,:) - X(rand_index2,:)));
            end
        else
            Yt = 2*rand*(1-t/Max_iterations)^(t/Max_iterations);
            U2 = rand(1,dimensions) < 0.5*2-1;
            S = rand*U2;
            if rand < Tf 
                St = exp(fitness(i)/(sum(fitness)+eps));
                S = S.*Yt.*St;
                rand_index1 = randi(Search_Agents);
                rand_index2 = randi(Search_Agents);
                rand_index3 = randi(Search_Agents);
                X(i,:) = (1-U1).*X(i,:) + U1.*(X(rand_index1,:) + St*(X(rand_index2,:) - X(rand_index3,:)) - S);
            else 
                Mt = exp(fitness(i)/(sum(fitness)+eps));
                vt = X(i,:);
                rand_index = randi(Search_Agents);
                Vtp = X(rand_index,:);
                Ft = rand(1,dimensions).*(Mt*(-vt+Vtp));
                S = S.*Yt.*Ft;
                X(i,:) = (Best_pos + (alpha*(1-r2)+r2)*(U2.*Best_pos-X(i,:))) - S;
            end
        end
        
        
        X(i,:) = max(X(i,:), Lowerbound);
        X(i,:) = min(X(i,:), Upperbound);
        
        
        new_fitness = objective(X(i,:));
        
        
        if new_fitness < fitness(i)
            Xp(i,:) = X(i,:);
            fitness(i) = new_fitness;
            if new_fitness < Score
                Best_pos = X(i,:);
                Score = new_fitness;
            end
        else
            X(i,:) = Xp(i,:);
        end
    end
    
    t = t + 1;
    CPO_curve(t) = Score;
    
   
    New_Search_Agents = fix(N_min + (Search_Agents - N_min) * (1 - (rem(t, Max_iterations/T) / (Max_iterations/T))));
    
    if New_Search_Agents < Search_Agents
        [~, sorted_indexes] = sort(fitness);
        X = X(sorted_indexes(1:New_Search_Agents), :);
        Xp = Xp(sorted_indexes(1:New_Search_Agents), :);
        fitness = fitness(sorted_indexes(1:New_Search_Agents));
        Search_Agents = New_Search_Agents;
    end
end

end


function X = initialization(SearchAgents_no, dim, ub, lb)
    Boundary_no = size(ub, 2);
    if Boundary_no == 1
        X = rand(SearchAgents_no, dim) .* (ub - lb) + lb;
    else
        for i = 1:dim
            ub_i = ub(i);
            lb_i = lb(i);
            X(:, i) = rand(SearchAgents_no, 1) .* (ub_i - lb_i) + lb_i;
        end
    end
end