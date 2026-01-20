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
% -------- deutero erwtima-----------
coilcode_oct = data.EDduration(strcmp(data.CoilCode, '1')); % Για πηνίο οκτάρι
coilcode_round = data.EDduration(strcmp(data.CoilCode, '0')); % Για πηνίο στρογγυλό
num_samples =1000;

%resampling


[chi2_oct , p_value_oct] = bootstrap_test(coilcode_oct , num_samples);
[chi2_round, p_value_round] = bootstrap_test(coilcode_round, num_samples);

fprintf('Πηνίο οκτάρι: Χ^2 = %.4f, p-value = %.4f\n', chi2_oct, p_value_oct);
fprintf('Πηνίο στρογγυλό: Χ^2 = %.4f, p-value = %.4f\n', chi2_round, p_value_round);
%ypologismos χ0^2
[chi2_oct_0] = chi_square_statistic(coilcode_oct, 1/mean(coilcode_oct));
[chi2_round_0] = chi_square_statistic(coilcode_round, 1/mean(coilcode_round));
fprintf('Πηνίο οκτάρι: Χ0^2 = %.4f\n', chi2_oct);
fprintf('Πηνίο στρογγυλό: Χ0^2 = %.4f\n', chi2_round);

%Paratiroyme oti gia epipedo simantikotitas 0.05 to phnio oktari
%apporiptetai h ypothesi H0 gia ekthetikh katanomi . To idio simvainei kai
%apo to X^2 kathws brisketai sth deksia oura. Gia to pinio stroggulo exoume
%mi aporripsi kai twn dyo synthikwn