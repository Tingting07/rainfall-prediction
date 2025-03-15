function [pcc,R2,mae,rmse,mape,error]=calc_error(x1,x2)

 error=x2-x1;  %�������
 rmse=sqrt(mean(error.^2));
 disp(['1.��������(RMSE)��',num2str(rmse)])

 mae=mean(abs(error));
disp(['2.ƽ��������MAE����',num2str(mae)])
 mbe = mean(error);
disp(['3.ƽ��������MBE����',num2str(mbe)])
 mape=mean(abs(error)/x1);
 disp(['4.ƽ����԰ٷ���MAPE����',num2str(mape*100),'%'])

 RSS = sum((x2 - x1).^2);
 TSS = sum((x1 - mean(x1)).^2);
 R2 = 1 - (RSS / TSS);
  disp(['5.����ϵ����R2����',num2str(R2),])

  % �����ֵ
    mu_x = mean(x1);
    mu_y = mean(x2);
    
    % ����Э����ͱ�׼��
    cov_xy = sum((x1 - mu_x) .* (x2 - mu_y));
    std_x = sqrt(sum((x1 - mu_x) .^ 2));
    std_y = sqrt(sum((x2 - mu_y) .^ 2));
    
    % ����Pearson���ϵ��
    pcc = cov_xy / (std_x * std_y);
    disp(['6.pcc��',num2str(pcc),])
end

