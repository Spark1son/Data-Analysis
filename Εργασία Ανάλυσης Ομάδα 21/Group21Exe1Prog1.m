%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748


filename = 'TMS.xlsx';
data = readtable(filename);

ED_with_TMS = data.EDduration(data.TMS == 1);
ED_without_TMS = data.EDduration(data.TMS == 0);


distributions = {'Normal', 'Exponential', 'Weibull', 'Gamma', 'Lognormal'};
results_with_TMS = [];
results_without_TMS = [];
X2_with_TMS = [];
X2_without_TMS = [];

%dokimi katanomwn gia ti diarkeia ED me tms 
disp('distributions for ED with TMS:');
for i = 1:length(distributions)
    try
        pd = fitdist(ED_with_TMS, distributions{i});
        results_with_TMS = [results_with_TMS; {distributions{i}, pd}];
        % Ypologismos X^2
        [f_obs, edges] = histcounts(ED_with_TMS, 'Normalization', 'pdf');
        f_exp = pdf(pd, edges(1:end-1) + diff(edges)/2);
        X2 = sum((f_obs - f_exp).^2 ./ f_exp);
        X2_with_TMS = [X2_with_TMS; X2];
        fprintf('Distribution: %s, X² Statistic: %.2f\n', distributions{i}, X2);
    catch
        fprintf('Could not fit distribution: %s\n', distributions{i});
    end
end
disp('---------------------------------------------');
% Δοκιμή κατανομών για διάρκεια ED χωρίς TMS
disp('distributions for ED without TMS:');
for i = 1:length(distributions)
    try
        pd = fitdist(ED_without_TMS, distributions{i});
        results_without_TMS = [results_without_TMS; {distributions{i}, pd}];
        % Υπολογισμός X² για την κατανομή
        [f_obs, edges] = histcounts(ED_without_TMS, 'Normalization', 'pdf');
        f_exp = pdf(pd, edges(1:end-1) + diff(edges)/2);
        X2 = sum((f_obs - f_exp).^2 ./ f_exp);
        X2_without_TMS = [X2_without_TMS; X2];
        fprintf('Distribution: %s, X² Statistic: %.2f\n', distributions{i}, X2);
    catch
        fprintf('Could not fit distribution: %s\n', distributions{i});
    end
end

%Euresi kaliteris katanomis me vasi to X^2
[~, best_method_with_TMS] = min(X2_with_TMS);
[~, best_method_without_TMS] = min(X2_without_TMS);
best_fit_with_TMS = results_with_TMS{best_method_with_TMS, 2};
best_fit_without_TMS = results_without_TMS{best_method_without_TMS, 2};

%figures
figure;


subplot(2, 1, 1);
% spp xwris TMS
histogram(ED_without_TMS, 'Normalization', 'pdf', 'DisplayName', 'Histogram Without TMS');
hold on;
x_values = linspace(min(ED_without_TMS), max(ED_without_TMS), 100);
for i = 1:size(results_without_TMS, 1)
    pd = results_without_TMS{i, 2};
    plot(x_values, pdf(pd, x_values), 'LineWidth', 1.5, 'DisplayName', results_without_TMS{i, 1});
end
legend;
xlabel('Duration (seconds)');
ylabel('Probability Density');
title('All Fits for ED Without TMS');


subplot(2, 1, 2);
% spp me TMS
histogram(ED_with_TMS, 'Normalization', 'pdf', 'DisplayName', 'Histogram With TMS');
hold on;
x_values = linspace(min(ED_with_TMS), max(ED_with_TMS), 100);
for i = 1:size(results_with_TMS, 1)
    pd = results_with_TMS{i, 2};
    plot(x_values, pdf(pd, x_values), 'LineWidth', 1.5, 'DisplayName', results_with_TMS{i, 1});
end
legend;
xlabel('Duration (seconds)');
ylabel('Probability Density');
title('All Fits for ED With TMS');

% Τελικό γράφημα με την καλύτερη κατανομή
figure;
subplot(1, 2, 1);
histogram(ED_without_TMS, 'Normalization', 'pdf', 'DisplayName', 'Histogram Without TMS');
hold on;
plot(x_values, pdf(best_fit_without_TMS, x_values), 'r-', 'LineWidth', 2, 'DisplayName', 'Best Fit');
title('Best Fit for ED Without TMS');
xlabel('Duration (seconds)');
ylabel('Probability Density');
legend;

subplot(1, 2, 2);
histogram(ED_with_TMS, 'Normalization', 'pdf', 'DisplayName', 'Histogram With TMS');
hold on;
x_values = linspace(min(ED_with_TMS), max(ED_with_TMS), 100);
plot(x_values, pdf(fitdist(ED_with_TMS, 'Exponential'), x_values), 'b-', 'LineWidth', 2, 'DisplayName', 'Best Fit');
title('Best Fit for ED With TMS');
xlabel('Duration (seconds)');
ylabel('Probability Density');
legend;


% Paratiriseis
% Anamenoume ipsilo X2 sto Normal distribution. H methodos den einai
% idaniki kathws ta stoixeia xi den kathos ta dedomena den emfanizoun
% symmetria gyrw apo ti mesi timi kai genikotera i normal distr einai
% symmetriki
% Gia ED me kai xwris TMS vlepoume oti i katanomi X^2 exei idia timi gia expontential
% kai lognormal distribution. Epilegoume sti mia exp kai stin alli
% periptwsi lognormal
