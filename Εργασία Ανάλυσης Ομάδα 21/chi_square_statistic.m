%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

function [chi2_stat] = chi_square_statistic(data, lambda)
    % Υπολογισμός παρατηρηθεισών συχνοτήτων
    [f_obs, edges] = histcounts(data, 'Normalization', 'pdf');
    bin_centers = edges(1:end-1) + diff(edges)/2;
    
    % Υπολογισμός αναμενόμενων συχνοτήτων για την εκθετική κατανομή
    f_exp = lambda * exp(-lambda * bin_centers);
    
    % Υπολογισμός Χ^2 για το αρχικό δείγμα
    chi2_stat = sum((f_obs - f_exp).^2 ./ f_exp);
    
end