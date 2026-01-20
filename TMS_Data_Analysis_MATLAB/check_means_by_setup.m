%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

function results = check_means(data, mu_0, setups, alpha)
    results = table();
    for s = setups'
        group_data = data.EDduration(data.Setup == s & ~isnan(data.EDduration));
        [h, p_normal] = chi2gof(group_data);
        
        if h == 0 
            n = length(group_data);
            x_bar = mean(group_data);
            se = std(group_data) / sqrt(n); % typiko sfalma 
            ci = x_bar + tinv([alpha/2, 1-alpha/2], n-1) * se;
        else
            
            ci = bootci(1000, {@mean, group_data}, 'Alpha', alpha); %diastima empistosynis mesw bootstrap 
        end
        
       
        reject_null = ~(mu_0 >= ci(1) && mu_0 <= ci(2)); %aporripsi midenikis ipothesis 
        results = [results; {s, mean(group_data), ci(1), ci(2), p_normal, reject_null}];
    end
    results.Properties.VariableNames = {'Setup', 'Mean', 'Katw orio', 'Ano orio', 'P_Normal', 'Apporipsi_H0'};
end
% otan ta dedomena einai kanonika xrisimopoio ti p-timi gia elegxo
% ypothesis enw an xrisimopoiw bootstrap deigmata aksiopoiw to diastima
% empistosynhs kai ypologzw katw kai anw orio 