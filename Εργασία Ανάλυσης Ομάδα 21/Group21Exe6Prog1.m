
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
disp(var(x));

disp(x)

% plires montelo (oles oi metavlites) mesw tis synartisis fitlm
model_full = fitlm(x, Y);

%ypologizw meso tetragwniko sfalma 
e_full = model_full.Residuals.Raw;

mse_full = mean(e_full.^2);

%Prosarmosmenos syntelestis prosdiorismou. Pairnw adj giati kai sth
%projhgoumenh askhsh den ebgaza NaN me adj opote pira afto.
adj_r2_full = model_full.Rsquared.Adjusted;

disp('Plires montelo:');
disp(['MSE: ', num2str(mse_full)]);
disp(['Adj R^2: ', num2str(adj_r2_full)]);
% montelo vimatikis palindromisis (xrisimopoihsa th function stepwise
% regression pou vriska gia epilogi simantikoterwn metavlitwn poy fainontai
% katw
model_stepwise = stepwiselm(x, Y, 'linear', 'Upper', 'linear', 'Criterion', 'rsquared'); % me kritirio r^2 epeidi o adj krataei oles tis metavlites akoma kai aftes pou den voithane sti veltioisi tou modelou


% MSE, adj R^2
e_stepwise = model_stepwise.Residuals.Raw;
mse_stepwise = mean(e_stepwise.^2);
adj_r2_stepwise = model_stepwise.Rsquared.Adjusted;

disp('Montelo Vimatikis Pal:');
disp(['MSE: ', num2str(mse_stepwise)]);
disp(['Adj R^2: ', num2str(adj_r2_stepwise)]);
disp('Epilegmenes metavlites:');
disp(model_stepwise.Formula);
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
disp(corr_matrix);
model_full = fitlm(x, Y);
disp(model_full.Coefficients);
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

disp('LASSO:');
disp(['MSE: ', num2str(mse_lasso)]);
disp(['Adj R^2: ', num2str(adj_r2_lasso)]);



%apo ta apotelesmata vlepoume oti oi i methodos tis vimatikis exei
%auksimeno lasso alla exei ligoteres metavlites . To plires montelo exei to
%megalitero adjR^2 to oppoio simainei oti eksigei kalytera ti metavlitotita
%toy Y . To lasso exei to xamilotero adjR2 = 0.20052. To plires montelo
%einai elafrws kalitero sto na eksigei metablitotita. h vimatiki
%palindromisi einai to kalytero gia aplotita kai ermineusimotita kathws
%xrisimopoeiei mono 2 metavlites (x1,x5) me mikri meiwsh sto adjR2
%to lasso exei to pleonektima tis kanonikopoihshs. Ara analoga me to ti
%stoxo exoume , exoume diaforetiko "kalytero" modelo. An proteraiothta
%einai h akribeia problepsis epilegw ti lasso , an einai i ermineusimothta
%to modelo ths vhmatikhs enw an einai i metabalothta kalhytero modelo einai
%to plires
%Me tis afairesh ths Spike metavlitis to mse kai to adjR^2 allaksan ligo
%epeidh ta modela vasizontai se ligoteres metavlites. gia paradeigma to MSE
%sto plires montelo apo 106.1762 anevike sto 106.2644 kai to R^2 0.23->0.24
%episis oi epilegmenes metavlites sti vimatiki einai oi idies   , enw
%to MSE kai to R62 den allakse
%Telos, sti lasso den eixame kapoia allagi sta MSE kai ADJ . I spike eixe
%sigoura epidrasi apla oxi kai toso simantiki epeidh ousiastika emeinan
%idia.
