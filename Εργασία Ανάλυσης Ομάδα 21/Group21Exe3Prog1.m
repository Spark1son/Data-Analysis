%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

no_tms = data(data.TMS == 0, :); % Dedomena xwris TMS
with_tms = data(data.TMS == 1, :); %Dedomena TMS 
mu_0 = mean(no_tms.EDduration);


setups = unique(data.Setup);


alpha = 0.05;
results_no_tms = check_means(no_tms, mu_0, setups, alpha);
results_with_tms = check_means(with_tms, mu_0, setups, alpha);
disp('Results Without TMS:');
disp(results_no_tms);
disp('Results With TMS:');
disp(results_with_tms);
%H xorigisi TMS fainetai na epireazei ti mesi diarkeia ED se kapoia setups (px 2, 4, 5),
% me simantiki meiosi sti mesi timi. 
% Se setups opos to 1 kai to 4, ta apotelesmata me kai xoris TMS einai
% sxedon paromoia 
% Genika, i aporripsi tis H0 diaferei metaksi ton periptoseon, deixnontas oti to TMS mporei
% na allazei ti statistiki symperifora tis diarkeias ED.