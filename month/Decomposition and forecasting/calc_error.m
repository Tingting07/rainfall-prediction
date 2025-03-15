function [pcc,R2,mae,rmse,mape,error]=calc_error(x1,x2)

 error=x2-x1;  %计算误差
 rmse=sqrt(mean(error.^2));
 disp(['1.根均方差(RMSE)：',num2str(rmse)])

 mae=mean(abs(error));
disp(['2.平均绝对误差（MAE）：',num2str(mae)])
 mbe = mean(error);
disp(['3.平均绝对误差（MBE）：',num2str(mbe)])
 mape=mean(abs(error)/x1);
 disp(['4.平均相对百分误差（MAPE）：',num2str(mape*100),'%'])

 RSS = sum((x2 - x1).^2);
 TSS = sum((x1 - mean(x1)).^2);
 R2 = 1 - (RSS / TSS);
  disp(['5.决定系数（R2）：',num2str(R2),])

  % 计算均值
    mu_x = mean(x1);
    mu_y = mean(x2);
    
    % 计算协方差和标准差
    cov_xy = sum((x1 - mu_x) .* (x2 - mu_y));
    std_x = sqrt(sum((x1 - mu_x) .^ 2));
    std_y = sqrt(sum((x2 - mu_y) .^ 2));
    
    % 计算Pearson相关系数
    pcc = cov_xy / (std_x * std_y);
    disp(['6.pcc：',num2str(pcc),])
end

