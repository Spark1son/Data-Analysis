%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

function [r, R2] = ypologismos_syntelesti_prosd_r(x, y)
   
    n = length(x);
    x_mean = mean(x);
    y_mean = mean(y);
    
   
    arithmitis = sum(x .* y) - n * x_mean * y_mean;
    paronomastis = sqrt((sum(x.^2) - n * x_mean^2) * (sum(y.^2) - n * y_mean^2));

    r = arithmitis / paronomastis;
    
    R2 = r^2;
end
