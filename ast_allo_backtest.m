%% Function to calculate asset allocation, turnover and perform backtest
function [ opt_Assets, turn_over, meanRet_exPost, P1, P2, stdDev_exPost ] = ast_allo_backtest(CRR, RF, expRet, optPort, winDataExPost)

P1  = zeros(11,1);              %percentage in stocks
P2  = zeros(11,1);              %percentage in bank
netchange = cell(10,1);
turn_over = zeros(10,1);
optPort_meanRet = cell(11,1);   % Yearly ER of opt portfolio in each window
opt_Assets = cell(11,1);

for i = 1:11
   optPort_meanRet{i} = expRet(i,:)*optPort{i,1};
   if CRR == 0   %if condition is setup for BL case where CRR not needed
      P1(i) = 1;
      P2(i) = 0;
      opt_Assets{i} = [P1(i)*optPort{i,1}];
   else
   P1(i) = (CRR - RF)/(optPort_meanRet{i} - RF);
   P2(i) = 1 - P1(i);
   opt_Assets{i} = [P1(i)*optPort{i,1}; P2(i)];
   end
end

for i = 1:10
   netchange{i} = P1(i+1).*optPort{i+1,1} - P1(i).*optPort{i,1};
   turn_over(i) = sum(abs(netchange{i}));
end
%We add the turnover of 1st window: TO_1 = sum of absolute values P1*port
turn_over = [sum(abs(P1(1).*optPort{1,1})); turn_over];

%Asset allocation plot
for i=1:11
    assAllplot(:,i) = opt_Assets{i,:};
end
if CRR ~= 0   %if condition to plot only for Asset Allocation not BL model
  X = 2005:2015;
  figure('Position', [100, 0, 1000,1000]);
  %ColorSet = varycolor(9);
  %set(gca, 'ColorOrder', ColorSet);
    for i=1:10
        plot(X, assAllplot(i,:), '.-', 'MarkerSize', 15);
        hold on;
    end
  set(gca,'fontsize',14);
  set(gcf, 'Color', 'w');
  legend('XLE','XLU', 'XLK', 'XLB','XLP','XLY','XLI','XLV','XLF', 'P2', 'Orientation', 'horizontal', 'Location', 'North');
  ylabel('Asset Allocation Weights');
  hold off;
  saveas(gcf, 'AssetAllPlot.png');    
end
%% f) Backtest: calculate return out-of-sample and rebalance
%     The actual return we made with our portfolio starting in 2005 onto
%     2015 (11 yrs of return performance).

meanRet_exPost = zeros(11,1);
stdDev_exPost = zeros(11,1);
port_yearlyMeanExPost = zeros(11,9);

for i=1:11
    port_yearlyMeanExPost(i,:) = 12*mean( [winDataExPost{i}] );
    meanRet_exPost(i) = P1(i)*port_yearlyMeanExPost(i,:)*optPort{i,1} + P2(i)*RF;
    stdDev_exPost(i) = sqrt((P1(i)*optPort{i,1})'*(12*cov(winDataExPost{i}))*(P1(i)*optPort{i,1}));
end