clc;
clear 
close all
tic
disp('…………………………………………………………………………………………………………………………')
disp('VMD-CNN-GRU预测')
disp('…………………………………………………………………………………………………………………………')
load origin_data.mat
load vmd_data.mat       

imf=u;
c=size(imf,1);
num_samples = length(X);       
kim = 12;                     
zim =  2;                     
or_dim = size(X,2);
for i = 1: num_samples - kim - zim + 1
    res(i, :) = [reshape(X(i: i + kim - 1,:), 1, kim*or_dim), X(i + kim + zim - 1,:)];
end
outdim = 1;                                  
num_train_s = 516; 
f_ = size(res, 2) - outdim;                  
P_train = res(1: num_train_s, 1: f_)';
T_train = res(1: num_train_s, f_ + 1: end)';
M = size(P_train, 2);
P_test = res(num_train_s + 1: end, 1: f_)';
T_test = res(num_train_s + 1: end, f_ + 1: end)';
N = size(P_test, 2);
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);
[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);
T_train1 = T_train;
T_test2 = T_test;
for d=1:c
disp(['第',num2str(d),'个分量建模'])

X_imf=[X(:,1:end-1) imf(d,:)'];
num_samples = length(X_imf);  

for i = 1: num_samples - kim - zim + 1
    res(i, :) = [reshape(X_imf(i: i + kim - 1,:), 1, kim*or_dim), X_imf(i + kim + zim - 1,:)];
end
num_train_s = 516;
outdim = 1;                                
f_ = size(res, 2) - outdim;                  
P_train = res(1: num_train_s, 1: f_)';
T_train = res(1: num_train_s, end)';
M = size(P_train, 2);          


P_test = res(num_train_s + 1: end, 1: f_)';
T_test = res(num_train_s + 1: end, end)';
N = size(P_test, 2);

%  数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%  格式转换
for i = 1 : M 
    vp_train{i, 1} = p_train(:, i);
    vt_train{i, 1} = t_train(:, i);
end

for i = 1 : N 
    vp_test{i, 1} = p_test(:, i);
    vt_test{i, 1} = t_test(:, i);
end
lgraph = layerGraph();                                                  
tempLayers = [
    sequenceInputLayer([f_ , 1, 1], "Name", "sequence")             
    sequenceFoldingLayer("Name", "seqfold")];                          
lgraph = addLayers(lgraph, tempLayers); 
tempLayers = [
    convolution2dLayer([12, 1], 32, "Name", "conv", "Padding", "same")  
    batchNormalizationLayer('name','batchnorm1')
    reluLayer("Name", "relu")];                                        
    maxPooling2dLayer([2,1],'Stride',2,'Padding','same','name','maxpool')
lgraph = addLayers(lgraph, tempLayers);                                                         
tempLayers = [ 
    sequenceUnfoldingLayer("Name", "sequnfold")                      
    flattenLayer("Name", "flatten")                                  
    gruLayer(60, "Name", "gru", "OutputMode","sequence")                 
    dropoutLayer(0.1 ,'name','dropout_1')       
    fullyConnectedLayer(1, "Name", "fc")                         
    regressionLayer("Name", "regression")];                          
lgraph = addLayers(lgraph, tempLayers);                                
lgraph = connectLayers(lgraph, "seqfold/out", "conv");             
lgraph = connectLayers(lgraph, "seqfold/miniBatchSize", "sequnfold/miniBatchSize"); 
                                                                    
lgraph = connectLayers(lgraph, "relu", "sequnfold/in");            
%% 设置训练参数
options = trainingOptions('adam', ...      % Adam 梯度下降算法
    'MaxEpochs', 200, ...                 % 最大迭代次数 
    'MiniBatchSize', 32, ...               % 批量大小 
    'GradientThreshold',1,...              % 渐变的正阈值 1
    'InitialLearnRate', 0.01, ...          % 初始学习率
    'LearnRateSchedule', 'piecewise', ...  % 学习率下降
    'LearnRateDropFactor', 0.5, ...        % 学习率下降因子 0.5
    'LearnRateDropPeriod', 150, ...         % 经过迭代学习率
    'SequenceLength',64,...                % 序列长度
    'Shuffle', 'every-epoch', ...          % 打乱数据集
    'Plots', 'none', ...                   % 画出曲线
    'Verbose', true);
net = trainNetwork(vp_train, vt_train, lgraph, options);

t_sim5 = predict(net, vp_train); 
t_sim6 = predict(net, vp_test); 

T_sim5_imf = mapminmax('reverse', t_sim5, ps_output);
T_sim6_imf = mapminmax('reverse', t_sim6, ps_output);

T_sim5(d,:) = cell2mat(T_sim5_imf);
T_sim6(d,:) = cell2mat(T_sim6_imf);

end
% 各分量预测的结果相加
T_sim5=sum(T_sim5);
T_sim6=sum(T_sim6);
T_train5=T_train1;
T_test6=T_test2;

%% 指标计算
disp('训练集误差指标')
[mae5,rmse5,mape5,error5]=calc_error(T_train5,T_sim5);
fprintf('\n')

disp('测试集误差指标')
[mae6,rmse6,mape6,error6]=calc_error(T_test6,T_sim6);
fprintf('\n')