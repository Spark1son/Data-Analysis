%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

function [chi2, p_value] = bootstrap_test(arxiko_deigma, num_bootstrap)
     
    %Ypologismos ekthetikis
    lambda = 1 / mean(arxiko_deigma);
    
    %Ypologismos syxnotiutwn
    [f_obs, edges] = histcounts(arxiko_deigma, 'Normalization', 'pdf');
    bin_centers = edges(1:end-1) + diff(edges)/2;
    
    %Ypologismws expected sixn
    f_exp = lambda * exp(-lambda * bin_centers);
    chi2 = sum((f_obs - f_exp).^2 ./ f_exp);
    
    % bootstrap deigmata
    chi2_bootstrap = zeros(num_bootstrap, 1);
    for i = 1:num_bootstrap
       
        bootstrap_sample = exprnd(1 / lambda, size(arxiko_deigma));
        [f_obs_bootstrap, ~] = histcounts(bootstrap_sample, edges, 'Normalization', 'pdf');
        
        f_exp_bootstrap = lambda * exp(-lambda * bin_centers);
        
        %ypologismos X^2
        chi2_bootstrap(i) = sum((f_obs_bootstrap - f_exp_bootstrap).^2 ./ f_exp_bootstrap);
    end
    
    %p-timi
    p_value = mean(chi2_bootstrap >= chi2);
end