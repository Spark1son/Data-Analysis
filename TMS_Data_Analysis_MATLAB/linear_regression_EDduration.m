%ΑΝΔΡΕΑ ΣΕΓΚΑΝΙ 10770
%ΚΥΡΙΑΖΗΣ ΛΙΑΛΙΟΣ 10748

data = readtable('TMS.xlsx');
no_tms = data(data.TMS == 0, :); % Dedomena xwris TMS
with_tms = data(data.TMS == 1, :); %Dedomena TMS

results = grammiki_palindromisi(no_tms , with_tms);
disp(results);

%oi pinakes deixnoun oti to montelo palindromisis tairiazei kalytera stin
%periptosi me TMS kathws o prosmarmosmenos syntelestis r^2 einai 0.0762 enw stin periptosi 
%xwris TMS einai sxedon mideniko (-0.0015). Auto simainei oti to Setup
%epireazei ti diarkeia ED mono otan xorigitai tms . H epektasi tou mentelou
%se polyonomiko kapoioy vathmou tha mporouse na einai. Sti periptosi opou
%den exoume TMS h xamhlh arxikh epidosi deixnei oti i poly proseggisi isws
%den exei kapoia simantiki diafora. gia to TMS ua mporouse na voithisei an
%Genika exoume7.6% ths ED eksigitai apo ti grammiki sxesi me to Setup kai i
%p-timi =0.0014 deixnei oti yprxei shmantikh statistiki sxesi metaksi Setup
%kai diarkeias ED, opote tha mporouse 