function [chi2, p_value] = Group21Exe2Prog2(arxiko_deigma, num_bootstrap)
     
    % Υπολογισμός παραμέτρου εκθετικής κατανομής
    lambda = 1 / mean(arxiko_deigma);
    
    % Υπολογισμός παρατηρηθεισών συχνοτήτων
    [f_obs, edges] = histcounts(arxiko_deigma, 'Normalization', 'pdf');
    bin_centers = edges(1:end-1) + diff(edges)/2;
    
    % Υπολογισμός αναμενόμενων συχνοτήτων
    f_exp = lambda * exp(-lambda * bin_centers);
    chi2 = sum((f_obs - f_exp).^2 ./ f_exp);
    
    % Δημιουργία bootstrap δειγμάτων
    chi2_bootstrap = zeros(num_bootstrap, 1);
    for i = 1:num_bootstrap
        % Δημιουργία τυχαίου δείγματος από την εκθετική κατανομή
        bootstrap_sample = exprnd(1 / lambda, size(arxiko_deigma));
        
        % Υπολογισμός παρατηρηθεισών συχνοτήτων για το bootstrap δείγμα
        [f_obs_bootstrap, ~] = histcounts(bootstrap_sample, edges, 'Normalization', 'pdf');
        
        % Υπολογισμός αναμενόμενων συχνοτήτων
        f_exp_bootstrap = lambda * exp(-lambda * bin_centers);
        
        % Υπολογισμός Χ^2 για το bootstrap δείγμα
        chi2_bootstrap(i) = sum((f_obs_bootstrap - f_exp_bootstrap).^2 ./ f_exp_bootstrap);
    end
    
    % Υπολογισμός p-value
    p_value = mean(chi2_bootstrap >= chi2);
end
