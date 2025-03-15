function [pcc,R2,mae,rmse,mape,error]=calc_error(x1,x2)

 error=x2-x1;  
 rmse=sqrt(mean(error.^2));
 disp(['RMSE£º',num2str(rmse)])

 mae=mean(abs(error));
disp(['MAE£º',num2str(mae)])
 mbe = mean(error);
disp(['MBE£º',num2str(mbe)])
 mape=mean(abs(error)/x1);
 disp(['MAPE£º',num2str(mape*100),'%'])

 RSS = sum((x2 - x1).^2);
 TSS = sum((x1 - mean(x1)).^2);
 R2 = 1 - (RSS / TSS);
  disp(['R2£º',num2str(R2),])

  % 
    mu_x = mean(x1);
    mu_y = mean(x2);
    
    % 
    cov_xy = sum((x1 - mu_x) .* (x2 - mu_y));
    std_x = sqrt(sum((x1 - mu_x) .^ 2));
    std_y = sqrt(sum((x2 - mu_y) .^ 2));
    
    % 
    pcc = cov_xy / (std_x * std_y);
    disp(['pcc£º',num2str(pcc),])
end

