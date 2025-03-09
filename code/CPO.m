function [Score, Best_pos, CPO_curve] = CPO(Search_Agents, Max_iterations, Lowerbound, Upperbound, dimensions, objective)
% CPO: Crested Porcupine Optimization 算法
% 输入:
%   Search_Agents: 搜索代理数量
%   Max_iterations: 最大迭代次数
%   Lowerbound: 搜索空间下界
%   Upperbound: 搜索空间上界
%   dimensions: 问题维度
%   objective: 目标函数句柄

% 初始化搜索边界
Lowerbound = ones(1, dimensions) .* Lowerbound;
Upperbound = ones(1, dimensions) .* Upperbound;

% 初始化控制参数
N_min = 120; % 种群规模最小值
T = 2; % 循环数量
alpha = 0.2; % 收敛率
Tf = 0.8; % 第三和第四防御机制之间的权衡百分比

% 初始化种群和适应度
X = initialization(Search_Agents, dimensions, Upperbound, Lowerbound);
fitness = zeros(1, Search_Agents);
CPO_curve = zeros(1, Max_iterations);

% 计算初始适应度
for i = 1:Search_Agents
    fitness(i) = objective(X(i,:));
end

% 初始化全局最优
[Score, index] = min(fitness);
Best_pos = X(index, :);

% 存储每个峰冠豪猪个人最佳位置
Xp = X;

% 主循环
t = 0;
while t < Max_iterations
    r2 = rand;
    for i = 1:Search_Agents
        U1 = rand(1, dimensions) > rand;
        
        if rand < rand % 探索阶段
            if rand < rand % 第一防御机制
                rand_index = randi(Search_Agents);
                y = (X(i,:) + X(rand_index,:)) / 2;
                X(i,:) = X(i,:) + (randn) .* abs(2*rand*Best_pos - y);
            else % 第二防御机制
                rand_index1 = randi(Search_Agents);
                rand_index2 = randi(Search_Agents);
                y = (X(i,:) + X(rand_index1,:)) / 2;
                X(i,:) = (U1) .* X(i,:) + (1-U1) .* (y + rand*(X(rand_index1,:) - X(rand_index2,:)));
            end
        else
            Yt = 2*rand*(1-t/Max_iterations)^(t/Max_iterations);
            U2 = rand(1,dimensions) < 0.5*2-1;
            S = rand*U2;
            if rand < Tf % 第三防御机制
                St = exp(fitness(i)/(sum(fitness)+eps));
                S = S.*Yt.*St;
                rand_index1 = randi(Search_Agents);
                rand_index2 = randi(Search_Agents);
                rand_index3 = randi(Search_Agents);
                X(i,:) = (1-U1).*X(i,:) + U1.*(X(rand_index1,:) + St*(X(rand_index2,:) - X(rand_index3,:)) - S);
            else % 第四防御机制
                Mt = exp(fitness(i)/(sum(fitness)+eps));
                vt = X(i,:);
                rand_index = randi(Search_Agents);
                Vtp = X(rand_index,:);
                Ft = rand(1,dimensions).*(Mt*(-vt+Vtp));
                S = S.*Yt.*Ft;
                X(i,:) = (Best_pos + (alpha*(1-r2)+r2)*(U2.*Best_pos-X(i,:))) - S;
            end
        end
        
        % 边界检查
        X(i,:) = max(X(i,:), Lowerbound);
        X(i,:) = min(X(i,:), Upperbound);
        
        % 计算新适应度
        new_fitness = objective(X(i,:));
        
        % 更新个体最优和全局最优
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
    
    % 动态调整种群规模
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

% 辅助函数：初始化种群
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