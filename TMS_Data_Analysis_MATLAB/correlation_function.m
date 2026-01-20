%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

function results = sysxetisi(data, setups, alpha)
    results = table();

    for s = setups'
        
        group_data = data(data.Setup == s, :);
        preTMS = group_data.preTMS;
        postTMS = group_data.postTMS;

       
        n = length(preTMS);
        x_mean = mean(preTMS);
        y_mean = mean(postTMS);
        arithmitis = sum(preTMS .* postTMS) - n * x_mean * y_mean;
        paronomastis = sqrt((sum(preTMS.^2) - n * x_mean^2) * (sum(postTMS.^2) - n * y_mean^2));
        
        r = arithmitis/paronomastis;

        
        t_stat = r * sqrt((n - 2) / (1 - r^2));
        p_timi = 2 * (1 - tcdf(abs(t_stat), n - 2)); %pira etoimi synartisi ypologismou p-timis kathws i student itan arketa periploko na ylopoihthei 

        num_randomizations = 1000;
        r_random = zeros(num_randomizations, 1);
        for i = 1:num_randomizations
            postTMS_shuffled = postTMS(randperm(length(postTMS))); %random
            arithmitis_rand = sum(preTMS .* postTMS_shuffled) - n * x_mean * mean(postTMS_shuffled);
            paronomastis_rand = sqrt((sum(preTMS.^2) - n * x_mean^2) * ...
                                     (sum(postTMS_shuffled.^2) - n * mean(postTMS_shuffled)^2));
            r_random(i) = arithmitis_rand / paronomastis_rand;
        end
        p_rand = sum(abs(r_random) >= abs(r)) / num_randomizations;

        
        results = [results; {s, r, p_timi, p_rand}];
    end

    results.Properties.VariableNames = {'Setup', 'r', 'P_Param', 'P_Rand'};
end
