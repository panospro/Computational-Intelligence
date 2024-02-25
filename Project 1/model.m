clc
clear;
close all

%% Linear Controller
s = tf('s');
Gc = @(Kp, Ki)(Kp + Ki/s);

Kp = 9.2;
c = 2.2;
Ki = Kp * c; % 20.24

% Open Loop Function
sys= Gc(Kp, Ki) * (s+c)/((s+1)*(s+9));

% Closed Loop Function
H_closed= 60 * feedback(sys, 1, -1);

%%% Figures %%%
figure();
rlocus(sys);
title("Γεωμετρικός τόπος ριζών της συνάρτησης ανοιχτού βρόγχου")
figure();
rlocus(H_closed);
title("Γεωμετρικός τόπος ριζών της συνάρτησης  κλειστού βρόγχου")
figure();
step(sys)
title("Η απόκριση του ανοιχτού βρόγχου για βηματική είσοδο")
figure();
step(H_closed)
hold on;
title("Η απόκριση του κλειστού βρόγχου για βηματική είσοδο")

info = stepinfo(H_closed)

%% Initialize variables
myfis = readfis('myfis');
figure()
gensurf(myfis);
modelPath1 = "Scenraio 1\my_fuzzy.mdl";
modelPath2 = "Scenraio 1\my_fuzzy_after.mdl";
modelPath3 = "Scenario 2\my_fuzzy1.mdl";
modelPath4 = "Scenario 2\my_fuzzy2.mdl";
color1 = 'g';
color2 = 'r';
t = 0:0.01:16;

%% Scenario 1
% Gains: Kp = 9.2, c = 2.2,  Ki = 20.24
out = sim(modelPath1)
plot(out.simout.Time, out.simout.Data);
fInfo1 = stepinfo(out.simout.Data, out.simout.Time)

% With optimized gains
out = sim(modelPath2)
plot(out.simout.Time, out.simout.Data, color1);
fInfo2 =  stepinfo(out.simout.Data, out.simout.Time)
legend('Linear', 'Fuzzy with initial gains', 'Fuzzy with optimized gains');

%% Scenario 2
% Part 1
% Linear
figure();
given_graph = 60 * (t >= 0 & t < 4) + 20 * (t >= 4 & t < 8) + 40 * (t >= 8);
[y, t] = lsim(H_closed/60, given_graph, t);
plot(t, given_graph);
hold on;
plot(t, y, color1);
xlabel("Time")
ylabel("Amplitude")

% Fuzzy
out = sim(modelPath3);
fInfo3 = stepinfo(out.simout.Data, out.simout.Time);
plot(out.simout.Time, out.simout.Data, color2);
legend('Given Signal', 'Linear', 'Fuzzy');


% Part 2
% Linear
figure();
given_graph = 12 * t .* (t >= 0 & t < 5) + 60 * (t >= 5 & t < 8) + (120 - 7.5 *t) .* (t >= 8);
[y, t] = lsim(H_closed/60, given_graph, t);
plot(t, given_graph);
hold on;
plot(t, y, color1);
xlabel("Time")
ylabel("Amplitude")
    

% Fuzzy 
out = sim(modelPath4)
fInfo4 = stepinfo(out.simout.Data, out.simout.Time);
plot(out.simout.Time, out.simout.Data, color2);
legend('Given Signal', 'Linear', 'Fuzzy');

disp(info)
disp(fInfo1)
disp(fInfo2)
disp(fInfo3)
disp(fInfo4)



% %% Σχεδίαση Ασαφούς Ελεγκτή (fis)
% 
% 
% % Δημιουργία του fis
% fis = newfis('fis');
% 
% % Προσθήκη εισόδου και συναρτήσεων membership του σφάλματος
% fis = addInput(fis,[-1 1],'Name',"e(t)");
% fis = addMF(fis,"e(t)","trimf",[-1.25 ,-1    ,-0.75],'Name',"NV");
% fis = addMF(fis,"e(t)","trimf",[-1    ,-0.75 ,-0.5],'Name',"NL");
% fis = addMF(fis,"e(t)","trimf",[-0.75 ,-0.5  ,-0.25],'Name',"NM");
% fis = addMF(fis,"e(t)","trimf",[-0.5  ,-0.25 ,0],'Name',"NS");
% fis = addMF(fis,"e(t)","trimf",[-0.25 ,0     ,0.25],'Name',"ZR");
% fis = addMF(fis,"e(t)","trimf",[0     ,0.25  ,0.5],'Name',"PS");
% fis = addMF(fis,"e(t)","trimf",[0.25  ,0.5   ,0.75],'Name',"PM");
% fis = addMF(fis,"e(t)","trimf",[0.5   ,0.75  ,1],'Name',"PL");
% fis = addMF(fis,"e(t)","trimf",[0.75  ,1     ,1.25],'Name',"PV");
% 
% 
% % Προσθήκη εισόδου και συναρτήσεων membership της μεταβολής σφάλματος
% fis = addInput(fis,[-1 1],'Name',"edot(t)");
% fis = addMF(fis,"edot(t)","trimf",[-1.25 ,-1    ,-0.75],'Name',"NV");
% fis = addMF(fis,"edot(t)","trimf",[-1    ,-0.75 ,-0.5],'Name',"NL");
% fis = addMF(fis,"edot(t)","trimf",[-0.75 ,-0.5  ,-0.25],'Name',"NM");
% fis = addMF(fis,"edot(t)","trimf",[-0.5  ,-0.25 ,0],'Name',"NS");
% fis = addMF(fis,"edot(t)","trimf",[-0.25 ,0     ,0.25],'Name',"ZR");
% fis = addMF(fis,"edot(t)","trimf",[0     ,0.25  ,0.5],'Name',"PS");
% fis = addMF(fis,"edot(t)","trimf",[0.25  ,0.5   ,0.75],'Name',"PM");
% fis = addMF(fis,"edot(t)","trimf",[0.5   ,0.75  ,1],'Name',"PL");
% fis = addMF(fis,"edot(t)","trimf",[0.75  ,1     ,1.25],'Name',"PV");
% 
% % Προσθήκη εξόδου και συναρτήσεων membership 
% fis = addOutput(fis,[-1 1],'Name',"udot(t)");
% fis = addMF(fis,"udot(t)","trimf",[-1.25 ,-1    ,-0.75],'Name',"NV");
% fis = addMF(fis,"udot(t)","trimf",[-1    ,-0.75 ,-0.5],'Name',"NL");
% fis = addMF(fis,"udot(t)","trimf",[-0.75 ,-0.5  ,-0.25],'Name',"NM");
% fis = addMF(fis,"udot(t)","trimf",[-0.5  ,-0.25 ,0],'Name',"NS");
% fis = addMF(fis,"udot(t)","trimf",[-0.25 ,0     ,0.25],'Name',"ZR");
% fis = addMF(fis,"udot(t)","trimf",[0     ,0.25  ,0.5],'Name',"PS");
% fis = addMF(fis,"udot(t)","trimf",[0.25  ,0.5   ,0.75],'Name',"PM");
% fis = addMF(fis,"udot(t)","trimf",[0.5   ,0.75  ,1],'Name',"PL");
% fis = addMF(fis,"udot(t)","trimf",[0.75  ,1     ,1.25],'Name',"PV");
% 
% 
% % Προσθήκη κανόνα 
% ruleList=[1 1 1 1 1;
%           1 2 1 1 1;
%           1 3 1 1 1;
%           1 4 1 1 1;
%           1 5 1 1 1;
%           1 6 2 1 1;
%           1 7 3 1 1;
%           1 8 4 1 1;
%           1 9 5 1 1;
% 
%           2 1 1 1 1;
%           2 2 1 1 1;
%           2 3 1 1 1;
%           2 4 1 1 1;
%           2 5 2 1 1;
%           2 6 3 1 1;
%           2 7 4 1 1;
%           2 8 5 1 1;
%           2 9 6 1 1;
% 
%           3 1 1 1 1;
%           3 2 1 1 1;
%           3 3 1 1 1;
%           3 4 2 1 1;
%           3 5 3 1 1;
%           3 6 4 1 1;
%           3 7 5 1 1;
%           3 8 6 1 1;
%           3 9 7 1 1;
% 
%           4 1 1 1 1;
%           4 2 1 1 1;
%           4 3 2 1 1;
%           4 4 3 1 1;
%           4 5 4 1 1;
%           4 6 5 1 1;
%           4 7 6 1 1;
%           4 8 7 1 1;
%           4 9 8 1 1;
% 
%           5 1 1 1 1;
%           5 2 2 1 1;
%           5 3 3 1 1;
%           5 4 4 1 1;
%           5 5 5 1 1;
%           5 6 6 1 1;
%           5 7 7 1 1;
%           5 8 8 1 1;
%           5 9 9 1 1;
% 
%           6 1 2 1 1;
%           6 2 3 1 1;
%           6 3 4 1 1;
%           6 4 5 1 1;
%           6 5 6 1 1;
%           6 6 7 1 1;
%           6 7 8 1 1;
%           6 8 9 1 1;
%           6 9 9 1 1;
% 
%           7 1 3 1 1;
%           7 2 4 1 1;
%           7 3 5 1 1;
%           7 4 6 1 1;
%           7 5 7 1 1;
%           7 6 8 1 1;
%           7 7 9 1 1;
%           7 8 9 1 1;
%           7 9 9 1 1;
% 
%           8 1 4 1 1;
%           8 2 5 1 1;
%           8 3 6 1 1;
%           8 4 7 1 1;
%           8 5 8 1 1;
%           8 6 9 1 1;
%           8 7 9 1 1;
%           8 8 9 1 1;
%           8 9 9 1 1;
% 
%           9 1 5 1 1;
%           9 2 6 1 1;
%           9 3 7 1 1;
%           9 4 8 1 1;
%           9 5 9 1 1;
%           9 6 9 1 1;
%           9 7 9 1 1;
%           9 8 9 1 1;
%           9 9 9 1 1;];
% 
% fis = addRule(fis,ruleList);
 
% Για να μπορέσω να σώσω το fis σε αρχείο
% writeFIS(fis,'myfis');
% Για να μπορέσω να διαβάσω το αρχείο με το fis
% fis = readfis('myfis')




