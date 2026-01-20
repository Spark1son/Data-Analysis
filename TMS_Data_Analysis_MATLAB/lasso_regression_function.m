%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

function [beta, beta0] = lasso(x, y, lamda, tol, max_epanalipseis)
   
    [n, p] = size(x); % n:paratiriseis , p: metavlites
    beta = zeros(p, 1); 
    beta0 = mean(y); 
    e = y - beta0; 
    
    
    for iter = 1:max_epanalipseis
        beta_old = beta; 
        
        for j = 1:p
            %Sum(yi-b0 - sum(b*x))
            e = e + x(:, j) * beta(j);
            
            % Υπολογισμός x_j^2 και xj*e
            z_j = sum(x(:, j).^2);
            r_j = sum(x(:, j) .* e);
            
            % Ενημέρωση beta_j με soft-thresholding (z-λ if z>l, 0 if
            % |z|<=λ  , z+l if z<-λ)
            if abs(r_j) > lamda
                beta(j) = sign(r_j) * max(0, abs(r_j) - lamda) / z_j;
            else
                beta(j) = 0;
            end
            
            
            e = e - x(:, j) * beta(j);
        end
        
        %elegxos sykglisis
        if max(abs(beta - beta_old)) < tol
            break;
        end
    end
end
