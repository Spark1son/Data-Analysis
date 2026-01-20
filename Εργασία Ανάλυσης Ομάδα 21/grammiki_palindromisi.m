%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

function results = grammiki_palindromisi(no_tms , with_tms )
    n_no_tms = size(no_tms, 1);
    n_with_tms = size(with_tms, 1);

    % Έλεγχος για κενά δεδομένα
    if isempty(no_tms)
        error('Δεν υπάρχουν δεδομένα χωρίς TMS.');
    end
    if isempty(with_tms)
        error('Δεν υπάρχουν δεδομένα με TMS.');
    end

    % Ανάλυση χωρίς TMS
    disp('Ανάλυση Χωρίς TMS:');
    model_no_tms = fitlm(no_tms.Setup, no_tms.EDduration);
    disp(model_no_tms);

    % Υπολογισμός Συντελεστών Προσδιορισμού
    [r_no_tms, R2_no_tms] = ypologismos_syntelesti_prosd_r(no_tms.Setup, no_tms.EDduration); %ypologismos r^2 (sysxetisi metaksi twn pragmatikwn timwn y kai twn timwn poy provlepei to montelo)
    if n_no_tms > 2
        R2_adj_no_tms = 1 - (1 - R2_no_tms) * (n_no_tms - 1) / (n_no_tms - 2); % ypogismos tou adj epeidi prosarmozetai kalytera sta deigmata 
    else
        R2_adj_no_tms = NaN;
    end

    % Ανάλυση Υπολοίπων
    residuals_no_tms = model_no_tms.Residuals.Raw;
    figure;
    scatter(no_tms.Setup, residuals_no_tms);
    title('Υπόλοιπα Χωρίς TMS');
    xlabel('Setup');
    ylabel('Residuals');

    % Ανάλυση με TMS
    disp('Ανάλυση Με TMS:');
    model_with_tms = fitlm(with_tms.Setup, with_tms.EDduration);
    disp(model_with_tms);

    % Υπολογισμός Συντελεστών Προσδιορισμού
    [r_with_tms, R2_with_tms] = ypologismos_syntelesti_prosd_r(with_tms.Setup, with_tms.EDduration);
    if n_with_tms > 2
        R2_adj_with_tms = 1 - (1 - R2_with_tms) * (n_with_tms - 1) / (n_with_tms - 2);
    else
        R2_adj_with_tms = NaN;
    end

    % Ανάλυση Υπολοίπων
    residuals_with_tms = model_with_tms.Residuals.Raw;
    figure;
    scatter(with_tms.Setup, residuals_with_tms);
    title('Υπόλοιπα Με TMS');
    xlabel('Setup');
    ylabel('Residuals');

    % Αποθήκευση αποτελεσμάτων
    results = table({'No TMS'; 'With TMS'}, [r_no_tms; r_with_tms], ...
        [R2_adj_no_tms; R2_adj_with_tms], 'VariableNames', {'Condition', 'r', 'Adj_R2'});
end

