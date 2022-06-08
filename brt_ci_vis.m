% Example Matlab code to visualise BRT response curves with 95% confidence intervals
%
% This code works with the file names produced by the R script brt_ci_eg.R.
% Change the file names and variable names to adapt this to your data, making sure
%  to be consistent between the R and Matlab scripts.
%
%  Note that, because of the large number of subplots in my work (3 models; 15 predictors)
%  this script includes 2 versions of visualising the response functions. The first
%  automatically plots everything for one model, on a single page. The second
% uses manual repositioning of subplots to keep output from one model in a single column
%  that flows across 2 output A4 sheets.
%
% The same approach can be used to show how the response curves develop during the BRT
%  model build.
%
% This code uses errorbars for the confidence intervals, so that the spread of data points
% across the range of predictor values is clear. You could also use patch() to create solid
% colour regions for the confidence intervals.
  

%%%% Load data:

ddir='C:\Example\brt_CI95data4\';  % ADAPT THIS FOR YOUR FILE SYSTEM
  
% ddir = '/Volumes/Users/example/brt_CI95data4/' % version for MacOS - ADAPT FOR YOUR FILE SYSTEM

% 1. With argo data; 15 predictor variablesx100 intervals per response
%    NB 1st column is line number.

chlArgo_mean = load([ddir 'brt_D20181027_15CHL_argo_CI_allVars.txt']);
chlArgo_se   = load([ddir 'brt_D20181027_15CHL_argo_CI_allVarsSE.txt']);
chlArgo_x    = load([ddir 'brt_D20181027_15CHL_argo_CI_allVarsX.txt']);

varNames={'MLD_{ARGO}','S_{ARGO}','Depth','JD','SST','\nablaSST','dSST/dt',...
    'windspeed','PAR','w','M','EKE','Current','Ro','PAR(7)'};

%%%%
% Version 1 of visualisation - automatically generate subplots.
%
% This uses 95% confidence intervals. To get 99% intervals, change 1.96 to 2.576.
%
% 95% confidence spread is shown in grey; mean response function is shown in black.
% The y-scale is manually set to suit my data - comment line 35 out when you first
%   run the code for your data, and then use it if you want to tweak the y-scale.
%
% Plot: 1 figure, no arrangement of subplots. 5 rows, 3 columns=15
% predictor variables:
figure(1); clf;
for i=1:size(chlArgo_mean,1)
    subplot(5,3,i); 
    errorbar(chlArgo_x(i,2:end), chlArgo_mean(i,2:end), 1.96*chlArgo_se(i,2:end), 'color',[.7 .7 .7]);
    hold on; 
    plot(chlArgo_x(i,2:end),chlArgo_mean(i,2:end),'k')
    clear yl; yl=['f(' char(varNames(i)) ')']; ylabel(yl,'fontsize',8);
    xlabel(char(varNames(i)),'fontsize',8)
end

% Uncomment to print to png graphics file, adapting the output file name to your system:
% print('-dpng','-r300','c:\Example\example_responseCurves.png');


%%%%%
% Version 2 of visualisation - manually reposition the subplots. 
%
% In this example, I show 1 column (out of 3 in my work; 1 for each of 3 models).
% The third input to subplot() is what determines where in the 2-dimensional grid
% of subplots the current one is going to appear, so with 3 columns and 7 rows of
%  plots, plots 1, 4, 7 etc will be in the left-hand column.
%
figure(1); clf;  % CHL in column 1
fsx=9; % fontsize
sph = 0.1; % height
% With Argo
subplot(7, 3, 1) % MLD
    errorbar(chlArgo_x(1,2:end), chlArgo_mean(1,2:end), 1.96*chlArgo_se(1,2:end), 'color',[.7 .7 .7]);
    hold on; %title(varNames(i),'fontsize',10);
    plot(chlArgo_x(1,2:end),chlArgo_mean(1,2:end),'k')
    p1 = gca; grid on
    set(p1, 'position',[.08 .88 .2 sph],'xlim',[-2 6],'ylim',[-.03 .1],'fontsize',fsx)

subplot(7, 3, 4) % Sresid
    errorbar(chlArgo_x(2,2:end), chlArgo_mean(2,2:end), 1.96*chlArgo_se(2,2:end), 'color',[.7 .7 .7]);
    hold on; %title(varNames(i),'fontsize',10);
    plot(chlArgo_x(2,2:end),chlArgo_mean(2,2:end),'k')
    p4 = gca;; grid on
    set(p4, 'position',[.08 .745 .2 sph],'xlim',[-50 10],'ylim',[-.07 .15],'fontsize',fsx)

subplot(7, 3, 7) % z
    errorbar(chlArgo_x(3,2:end), chlArgo_mean(3,2:end), 1.96*chlArgo_se(3,2:end), 'color',[.7 .7 .7]);
    hold on; %title(varNames(i),'fontsize',10);
    plot(chlArgo_x(3,2:end),chlArgo_mean(3,2:end),'k')
    p7 = gca;; grid on
    set(p7, 'position',[.08 .605 .2 sph],'xlim',[-4 3.5],'ylim',[-.55 .6],'fontsize',fsx)

subplot(7, 3, 10) % JD
    errorbar(chlArgo_x(4,2:end), chlArgo_mean(4,2:end), 1.96*chlArgo_se(4,2:end), 'color',[.7 .7 .7]);
    hold on; %title(varNames(i),'fontsize',10);
    plot(chlArgo_x(4,2:end),chlArgo_mean(4,2:end),'k')
    p10 = gca;; grid on
    set(p10, 'position',[.08 .465 .2 sph],'xlim',[-2.5 2.5],'ylim',[-.8 .2],'fontsize',fsx)

subplot(7, 3, 13) % SST
    errorbar(chlArgo_x(5,2:end), chlArgo_mean(5,2:end), 1.96*chlArgo_se(5,2:end), 'color',[.7 .7 .7]);
    hold on; %title(varNames(i),'fontsize',10);
    plot(chlArgo_x(5,2:end),chlArgo_mean(5,2:end),'k')
    p13 = gca; grid on
    set(p13, 'position',[.08 .32 .2 sph],'xlim',[-4 2.5],'ylim',[-1 1],'fontsize',fsx)

subplot(7, 3, 16) % SSTgrad
    errorbar(chlArgo_x(6,2:end), chlArgo_mean(6,2:end), 1.96*chlArgo_se(6,2:end), 'color',[.7 .7 .7]);
    hold on; %title(varNames(i),'fontsize',10);
    plot(chlArgo_x(6,2:end),chlArgo_mean(6,2:end),'k')
    p16 = gca;; grid on
    set(p16, 'position',[.08 .18 .2 sph],'xlim',[-2 9],'ylim',[-.2 0.3],'fontsize',fsx)

subplot(7, 3, 19) % SSTdt 
    errorbar(chlArgo_x(7,2:end), chlArgo_mean(7,2:end), 1.96*chlArgo_se(7,2:end), 'color',[.7 .7 .7]);
    hold on; %title(varNames(i),'fontsize',10);
    plot(chlArgo_x(7,2:end),chlArgo_mean(7,2:end),'k')
    p19 = gca;; grid on
    set(p19, 'position',[.08 .032 .2 sph],'xlim',[-7 6.5],'ylim',[-.05 0.05],'fontsize',fsx)
    
% Uncomment to print to png graphics file, adapting the output file name to your system:
%print('-dpng','-r600','c:\Example\F_BRTfunctions_chl_1.png');

%%%%%%%%%%%%%%%%%%%% end visualisation version 2 - 1st column of plots.

