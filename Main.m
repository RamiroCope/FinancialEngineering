%% Final assignment %%

% Retrieve monthly data from all 9 ETF sectors and the S&P500

% Indices cell order:
%  1:  XLE = Energy
%  2:  XLU = Utilities
%  3:  XLK = Technology
%  4:  XLB = Materials
%  5:  XLP = Consumer Staples
%  6:  XLY = Consumer Discretionary
%  7:  XLI = Industrials
%  8:  XLV = Health Care
%  9:  XLF = Financials
% 10:  SNP = S&P500

clear;

if ~exist('stocks', 'var')
    stocks=hist_stock_data('01011999','01012016','frequency','m',...
                'XLE','XLU','XLK','XLB','XLP','XLY','XLI','XLV','XLF','^GSPC');
    
    % Log returns for all 9 ETFs.
    indices = cell(10,1); 
    
    for i = 1:9
        indices{i} = flipud(stocks(i).AdjClose);
        LogReturns(:,i) = diff(log(indices{i}));
    end
    
% Values for the S&P500    
    SNP.ret       = diff(flipud(log(stocks(10).AdjClose)));
    SNP.yearlyMu  =  12*mean(SNP.ret);
    SNP.yearlyVar =  12*cov(SNP.ret);
    
end

%% Break up data into 11 rolling windows

winData = cell(11,1);
winDataExPost = cell(11,1);
SNPdata = cell(11,1);
SNPdataExPost = cell(11,1);
SNPdataExPostnoflip = cell(11,1);

for j = 1:11
    if j<6
        span = 60+12*j;
        winData{j} = LogReturns(1:span,:);
        winDataExPost{j} = LogReturns(span +1:span+12,:);
        SNPdata{j} = SNP.ret(1:span,:);
        SNPdataExPost{j} = SNP.ret(span +1:span+12,:);
    else
        % Index range for a 10 year rolling window, shifting 12 steps (one year) per iteration
        lowWin = 1+12*(j-5);
        hiWin = 120+12*(j-5);
        
        if j == 11
            winData{j} = LogReturns(lowWin:hiWin,:);
            winDataExPost{j} = LogReturns(hiWin +1:hiWin+11,:);            
            SNPdata{j} = SNP.ret(lowWin:hiWin,:);
            SNPdataExPost{j} = SNP.ret(hiWin +1:hiWin+11,:);
        else
            winData{j} = LogReturns(lowWin:hiWin,:);
            winDataExPost{j} = LogReturns(hiWin +1:hiWin+12,:);
            SNPdata{j} = SNP.ret(lowWin:hiWin,:);
            SNPdataExPost{j} = SNP.ret(hiWin +1:hiWin+12,:);
        end
    end
end

%% Global Variable Declarations

% Constants
RF = 0.01;      % Risk free rate
RF2 = 0.25;     % Second "artificial" risk free rate

% Variables
yearlyMean = zeros(11,9);    % Yearly expected log returns
yearlyCov  = cell(11,1);     % Covariance matrices of the yearly log returns
opt_Port   = cell(11,2);     % Optimal portfolios (aka "the weights")

%% Plotting the efficient frontier with and without riskfree rate

yearlyCorr = cell(11,1);     % Correlation matrices of the log returns
sigmas = cell(11,1);         % Std dev vector for the log returns
opt_mu    = zeros(11,2);     % Expected return of optimal portfolios
opt_sigma = zeros(11,2);     % Std dev of the optimal portfolio

for j = 1:11
    yearlyMean(j,:) = 12*mean( [winData{j}] );
    yearlyCov{j}    = 12*cov(winData{j});
    [yearlyCorr{j}, sigmas{j}] = corrcov(yearlyCov{j});
    [opt_Port{j,1}, opt_mu(j,1), opt_sigma(j,1)] = highest_slope_portfolio(yearlyCorr{j}, RF, yearlyMean(j,:)', sigmas{j});
    [opt_Port{j,2}, opt_mu(j,2), opt_sigma(j,2)] = highest_slope_portfolio(yearlyCorr{j}, RF2, yearlyMean(j,:)', sigmas{j});
end

% Call efficient_frontier function to handle calculations and plotting
[mu_p, std_p] = efficient_frontier(opt_Port, yearlyMean, yearlyCov);

%% e) & f) asset allocation, portfolio turnover and backtest
% We choose 10% as our constant required return (CRR)
% CRR = P1 * Rp + P2 * RF

CRR = 0.1; %constant required return

% Function call to calculate asset allocation, returns and perform backtest
[ opt_Assets, turn_over, port_meanRetExPost, P1, P2, stdDev_exPost ] = ast_allo_backtest(CRR, RF, yearlyMean, opt_Port, winDataExPost);

%% Creating Asset Allocation LaTex table from opt_Assets
for i=1:11
    assetMat(:,i) = opt_Assets{i,:};
end
colLabels = {'2005', '2006','2007','2008','2009','2010','2011','2012','2013','2014','2015'};
rowLabels = {'XLE','XLU','XLK','XLB','XLP','XLY','XLI','XLV','XLF', 'P2'}; 
matrix2latex(assetMat,'AssTable.tex', 'rowLabels', rowLabels, 'columnLabels',colLabels, 'alignment', 'c', 'format', '%-6.2f');


%%  Just for plotting
SNP_exPostRet = zeros(11,1);
SNP_exPostRetnoflip = zeros(11,1);

for i=1:11
    SNP_exPostRet(i) = 12*mean(SNPdataExPost{i});
end

% Plot market returns vs. optimal portfolio returns out of sample
x = [2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015];
bar(x,[SNP_exPostRet port_meanRetExPost ])
title('Out of sample Market vs. Portfolio returns');
xlabel('Year');
ylabel('Expected returns in %');
legend('S&P500','Optimal Portfolio');

%% g) Betas for each ETF per window

port_retExPost = cell(11,1);

for j = 1:11
    port_retExPost{j} = winDataExPost{j}*opt_Port{j}*P1(j)+P2(j)*RF;
end

all_portRetExPost = cell2mat(port_retExPost);
all_SNPretExPost = cell2mat(SNPdataExPost);

lm_CAPM = fitlm(all_SNPretExPost - RF, all_portRetExPost - RF,'VarNames',{'beta','returns'});
%% Black-Litterman
%Market Cap of each ETF as percentage of the SNP500

% Market Cap of each ETF as percentage of the SNP500
% Weights collected from pie chart on http://www.sectorspdr.com/sectorspdr/

wXLE  = 0.0733;
wXLU  = 0.0311;
wXLK  = 0.2311;
wXLB  = 0.0285;
wXLP  = 0.0940;
wXLY  = 0.1216;
wXLI  = 0.1043;
wXLV  = 0.1425;
wXLF  = 0.1458+0.0277; % Real estate is a part of financials

% The order of the weights in the w vector is important!
% It depends on the same order in which we collected the data.
w_init = [ wXLE wXLU wXLK wXLB wXLP wXLY wXLI wXLV wXLF ];

gamma = 1.9; % risk aversion coef.
tau = 0.3; % precision factor

% our own views on the market

% XLE neutral
% XLU decrease
% XLK decrease
% XLB neutral
% XLP decrease
% XLY neutral
% XLI increase
% XLV increase
% XLF increase
P = [ 0 -1 -1 0 -1 0 1 1 1 ];

Sigma = 0.04; % Error used for uncertain views

% Percentage change (Create a vector with varying percentages for each ETF?)
V = 0.03;
w = cell(11,1); %For certain views
wU = cell(11,1); %For uncertain views
% weighted expected returns and certain views expected return for each window
for i = 1:11
    Pi(i,:) = gamma*yearlyCov{i}*w_init';
    ER(i,:) = Pi(i,:)' + ( tau * yearlyCov{i}) * P' * inv((P * tau * yearlyCov{i} * P')) * ( V - P * Pi(i,:)');
    ERU(i,:) = inv( (( tau * yearlyCov{i})^(-1) + P' * Sigma^(-1) * P)) * ( ( tau * yearlyCov{i})^(-1) * Pi(i,:)' + P' * Sigma^(-1) * V);
    w{i} = (gamma * yearlyCov{i})^(-1)* ER(i,:)';
    wU{i} = (gamma * yearlyCov{i})^(-1)* ERU(i,:)';
end

% Function call to calculate asset allocation, returns and perform backtest
% Certain views
[ BL_optAss, BL_turnOver, BL_expRetExPost, BLP1, BLP2, BL_stdDevExPost] = ast_allo_backtest(0, RF, yearlyMean, w, winDataExPost);
% Uncertain views
[ BL_optAssU, BL_turnOverU, BL_expRetExPostU,BLUP1, BLUP2,  BLU_stdDevExPost] = ast_allo_backtest(0, RF, yearlyMean, wU, winDataExPost);

% For linear regression of Black Litterman models

BL_portRetExPost = cell(11,1);
BLU_portRetExPost = cell(11,1);

for j = 1:11
    BL_portRetExPost{j} = winDataExPost{j}*w{j};
    BLU_portRetExPost{j} = winDataExPost{j}*wU{j};
end

BL_allPortRetExPost = cell2mat(BL_portRetExPost);
lm_BLCAPM = fitlm(all_SNPretExPost - RF, BL_allPortRetExPost - RF,'VarNames',{'beta','returns'});

BLU_allPortRetExPost = cell2mat(BL_portRetExPost);
lm_BLUCAPM = fitlm(all_SNPretExPost - RF, BLU_allPortRetExPost - RF,'VarNames',{'beta','returns'});

% Plotting expected returns and turnovers

% Expected returns out of sample comparisons
x = [2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015];
bar(x,[100*SNP_exPostRet 100*port_meanRetExPost 100*BL_expRetExPost 100*BL_expRetExPostU ])
title('Out of sample Market vs. Portfolio returns');
xlabel('Year');
ylabel('Expected returns in %');
legend('S&P500','Optimal Portfolio', 'Black Litterman', 'Black Litterman uncertain views');

%Turnover comparison
x = [2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015];
bar([100*turn_over 100*BL_turnOver 100*BL_turnOverU])
title('Turnover for each year');
xlabel('Year');
ylabel('Turnover in %');
legend('Optimal Portfolio', 'Black Litterman', 'Black Litterman uncertain views');

%% i) Treynor - Mazuy Timing

% Calculate: (R_it - R_Ft) = a_i + b_i(R_mt - R_Ft) + c_i(R_mt - R_Ft)^2 + e_it

% R_it - R_Ft := Return of fund i in period t minus the risk free rate
RitRft = zeros(131,1);
% R_mt - R_Ft := Return of the market index in period t minus the risk free rate
RmtRft = zeros(131,1);

RitRft = all_portRetExPost - RF;
RmtRft = all_SNPretExPost - RF;
lm_Timing = fitlm([RmtRft, RmtRft.^2], RitRft,'Varnames',{'beta','gamma(^2 term)','returns'});
