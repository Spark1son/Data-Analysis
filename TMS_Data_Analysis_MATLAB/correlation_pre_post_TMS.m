%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

no_tms = data(data.TMS == 0, :); % Dedomena xwris TMS
with_tms = data(data.TMS == 1, :); %Dedomena TMS 


alpha = 0.05;
setups_no_tms = unique(no_tms.Setup);
results_no_tms = sysxetisi(no_tms, setups_no_tms, alpha);

setups_with_tms = unique(with_tms.Setup);
results_with_tms = sysxetisi(with_tms, setups_with_tms, alpha);

disp('Αποτελέσματα Χωρίς TMS:');
disp(results_no_tms);

disp('Αποτελέσματα Με TMS:');
disp(results_with_tms);
% den parateireitai statistica simatniki sysxetisi metaksu pre TMS kai post
% tms stis perissoteres katastaseis metriseis. TO setup=4 parousiazei
% oriaki endiksi sysxetisis(p>0.05). O elegxos tyxaopoihshs einai pio
% aksiopistos , eidika se periptwseis opoy ta dedomena den akoloythoyn
% kanoniki katanomi
