%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

with_tms = data(data.TMS == 1, :);
% metatrepo se arithmitika dedomena gia na treksoun oi synartiseis fitlm
% kai lasso 
with_tms.Stimuli = str2double(with_tms.Stimuli);
with_tms.Intensity = str2double(with_tms.Intensity);
with_tms.Spike = str2double(with_tms.Spike); % gia to teleuataio erwtima apla vazw ws sxolio auti ti grammi kwdika 
with_tms.Frequency = str2double(with_tms.Frequency);
with_tms.CoilCode = str2double(with_tms.CoilCode);

x = [with_tms.Setup, with_tms.Stimuli, with_tms.Intensity, ...
      with_tms.Spike, with_tms.Frequency, with_tms.CoilCode]; % gia to teleutaio erwtima svinw to with_tms.Spike kai trexw to programma


%eksartimeni metavliti
Y = with_tms.EDduration;
% kenes times tis thetw se timi 0 
x = fillmissing(x, 'constant', 0);
Y = fillmissing(Y, 'constant', 0);


% plires montelo (oles oi metavlites) mesw tis synartisis fitlm
model_full = fitlm(x, Y);

%ypologizw meso tetragwniko sfalma 
e_full = model_full.Residuals.Raw;

mse_full = mean(e_full.^2);

%Prosarmosmenos syntelestis prosdiorismou. Pairnw adj giati kai sth
%projhgoumenh askhsh den ebgaza NaN me adj opote pira afto.
adj_r2_full = model_full.Rsquared.Adjusted;


% montelo vimatikis palindromisis (xrisimopoihsa th function stepwise
% regression pou vriska gia epilogi simantikoterwn metavlitwn poy fainontai
% katw
model_stepwise = stepwiselm(x, Y, 'linear', 'Upper', 'linear', 'Criterion', 'rsquared'); % me kritirio r^2 epeidi o adj krataei oles tis metavlites akoma kai aftes pou den voithane sti veltioisi tou modelou


% MSE, adj R^2
e_stepwise = model_stepwise.Residuals.Raw;
mse_stepwise = mean(e_stepwise.^2);
adj_r2_stepwise = model_stepwise.Rsquared.Adjusted;

% diagrafikan metavlites me ipsili p-timi
%LASSO - PARAMETERS 
lamda = 0.1; % gia ipsiles times l (px l=10 , l=1) eixa meaglytero MSE opote pira mia timi i opoia elaxistopoiiei to MSE kai pio katw apo ti timi 0.1 to R^2 den allazei 
tol = 1e-5; %parametros sygklisis tis lasso
max_iter = 1000; %max arithmos epanalipseon


x(:, [2, 3, 4, 6]) = [];
%x(:, [2,3,5]) = []; % GIA TO TELEUTAIO ERWTIMA TIS ASK To vgazw apo sxolio
%kai vazw to panw se sxolio
% Εφαρμογή LASSO
[beta_lasso, beta0_lasso] = lasso(x, Y, lamda, tol, max_iter);

corr_matrix = corr(x);

model_full = fitlm(x, Y);

n = size(x, 1);
% elegxo poia metavliti den exei synisfora kai ti diagrafw. 
% paratirw oti oi metavlites x2,x3,x4,x6 den einai simatnikes(p>0.05) opote
% tis afairw prin kalesw ti lasso  gia na mi dimiourghthei provlima sto
% pollaplasiasmo pinakwn



%MSE, adj
y_pred_lasso = x * beta_lasso + beta0_lasso;
e_lasso = Y - y_pred_lasso;
mse_lasso = mean(e_lasso.^2);
selected_vars = find(beta_lasso ~= 0);



r2_lasso = 1 - sum(e_lasso.^2) / sum((Y - mean(Y)).^2);
adj_r2_lasso = 1 - (1 - r2_lasso) * (n - 1) / (n - p - 1);


%-------------------ASKISI 7------------------------------
training_ratio = 0.8;

n = size(x, 1);
rng(42);
idx = randperm(n);

n_training = round(training_ratio * n);
training_idx = idx(1:n_training);
test_idx = idx(n_training+1:end);


x_train = x(training_idx, :);
y_train = Y(training_idx);
x_test = x(test_idx, :);
y_test = Y(test_idx);
disp(size(x_train));
selected_vars = [1, 2]; 

if max(selected_vars) > size(x_train, 2)
    error('Ο πίνακας x_train δεν περιέχει αρκετές στήλες για τις επιλεγμένες μεταβλητές.');
end

% x_train_stepwise
x_train_stepwise = x_train(:, selected_vars);
x_test_stepwise = x_test(:, selected_vars);
model_stepwise = fitlm(x_train_stepwise, y_train);
y_pred_stepwise = predict(model_stepwise, x_test_stepwise);
mse_stepwise = mean((y_test - y_pred_stepwise).^2);
disp(['MSE Vimatiki Palindromisi: ', num2str(mse_stepwise)]);

[beta_lasso, beta0_lasso] = lasso(x_train, y_train, lamda, 1e-4, 1000);
y_pred_lasso = x_test * beta_lasso + beta0_lasso;
mse_lasso = mean((y_test - y_pred_lasso).^2);
disp(['MSE (LASSO): ', num2str(mse_lasso)]);
 % to modelo lasso provlepei kalitera kathws exei xamilotero MSE sto synolo
 % testing . Auto deixnei oti to lasso exei kalyteri genikeush sta dedomena
 % elegxou ,pithanotata epeidh efarmozei kanonikopoihsh kai apofeygei thn
 % yperprosarmogi 
 %MSE Vimatiki Palindromisi: 408.5097
 %MSE (LASSO): 401.1107


model_stepwise_test = stepwiselm(x_test, y_test, 'linear', 'Criterion', 'rsquared');

%ekmathisi

y_pred_stepwise_test = predict(model_stepwise_test, x_test);

mse_stepwise_test = mean((y_test - y_pred_stepwise_test).^2);
disp(['MSE Training Set: ', num2str(mse_stepwise_test)]);

disp(model_stepwise_train.Formula);
% Y = b0 + b1x1 +b2x2 +b3(x1*x2) +e

[beta_lasso, beta0_lasso] = lasso(x_test, y_test, lamda, 1e-4, 1000);
% Προβλέψεις στο Training Set
y_pred_lasso_test = x_test * beta_lasso + beta0_lasso;

% Υπολογισμός MSE για το Training Set
mse_lasso_testing = mean((y_test - y_pred_lasso_test).^2);
disp(['MSE Training Set (LASSO): ', num2str(mse_lasso_testing)]);

%ΟΣον αφορα τις μεταβλητες έχουμε τις ιδιες με πριν και δεν αφαιρεσα τη
%spike αφού ούτως η αλλως δεν εχει κάποια σημαντική επίδραση 
%to lasso provlepei kalytera, kathws exei xamilotero MSE sto synolo elegxou
%An kai h vimatiki palindromisi exei megalytero MSE sto synolo ekmathisis h
%daifora auti mporei na ofeiletai se yperprosarmogi.