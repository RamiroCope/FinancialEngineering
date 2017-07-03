function [ mu_p, std_p ] = efficient_frontier(opt_Ports, yearlyMean, yearlyCov)

%% Linear combinations of 2 optimum portfolios to reveal efficient frontier
%  w/o borrowing (Risk free assets).
%we  need the mean var portfolio under two diff. hypothetical RF rates

N = 400;
k = 3;
mu_p  = zeros(11, 4*k*N +1);
std_p = zeros(11, 4*k*N +1);

% Going through different combinations to find the efficient frontier;
for j = 1:11
    for i = -2*k*N  :  2*k*N
        curr_port = i / N * opt_Ports{j,2} + (1 - i / N) * opt_Ports{j,1};
        mu_p (j, i + 2*k*N +1) = yearlyMean(j,:) * curr_port;
        std_p(j, i + 2*k*N +1) = sqrt(curr_port' * yearlyCov{j} * curr_port);
    end
end

%% Efficient frontiers when Borrowing IS allowed (RF assets available)
% 1st: Find the best Sharpe ratio of each curve
% 2nd: Draw a line between (0, 0.01) the 1% risk free rate and the
%      coordinates of the best Sharpe ratio.

Sharp     = zeros(11, 4801); 
for j=1:11
     Sharp(j,:) = mu_p(j,:) ./ std_p(j,:);
end
opt_Sharp = max(Sharp');                  %Values of best Sharpe Ratio

for j=1:11
    Index(j) = find(Sharp(j,:) == max(Sharp(j,:))); 
end
%hold on;
%plot (0, .01, 'o');
%pause;

RF_x   = zeros(11,3);
Opt1_y = zeros(11,3);

%%%%%%%%%%% Subplots %%%%%%%%%%%%%%

%ColorSet = varycolor(11);
%set(gca, 'ColorOrder', ColorSet);
legendInfo = cell(11,1);

subplot(2,2,1)      
for i=1:3
    plot(std_p(i,:), mu_p(i,:)) %, 'color', ColorSet(i,:)
    hold on
    RF_x(i,:)   = [0 std_p(i, Index(i)) 2*std_p(i,Index(i))];
    Opt1_y(i,:) = [.01  mu_p(i,Index(i)) (2*mu_p(i,Index(i)) - 0.01) ];
    legendInfo{i} = ['Window' num2str(i)];
end
axis([0 1.1 -0.2 1]);  
xlabel('Risk: Std. Deviation');
ylabel('Expected Return');
title('Windows 1-3')
legend(legendInfo(1:3),'Location','NorthWest');
plot(RF_x(1:3,2), Opt1_y(1:3,2), '+r', 'MarkerSize', 10);
line(RF_x(1,:), Opt1_y(1,:));
line(RF_x(2,:), Opt1_y(2,:));
line(RF_x(3,:), Opt1_y(3,:));

subplot(2,2,2)
for i=4:6
    plot(std_p(i,:), mu_p(i,:)) %, 'color', ColorSet(i,:)
    hold on
    RF_x(i,:)   = [0 std_p(i, Index(i)) 2*std_p(i,Index(i))];
    Opt1_y(i,:) = [.01  mu_p(i,Index(i)) (2*mu_p(i,Index(i)) - 0.01) ];
    legendInfo{i} = ['Window' num2str(i)];
end
axis([0 0.7 -0.2 0.55]);  
xlabel('Risk: Std. Deviation');
ylabel('Expected Return');
title('Windows 4-6')
legend(legendInfo(4:6),'Location','NorthWest');
plot(RF_x(4:6,2), Opt1_y(4:6,2), '+r', 'MarkerSize', 10);
line(RF_x(4,:), Opt1_y(4,:));
line(RF_x(5,:), Opt1_y(5,:));
line(RF_x(6,:), Opt1_y(6,:));

subplot(2,2,3)
for i=7:9
    plot(std_p(i,:), mu_p(i,:)) %, 'color', ColorSet(i,:)
    hold on
    RF_x(i,:)   = [0 std_p(i, Index(i)) 2*std_p(i,Index(i))];
    Opt1_y(i,:) = [.01  mu_p(i,Index(i)) (2*mu_p(i,Index(i)) - 0.01) ];
    legendInfo{i} = ['Window' num2str(i)];
end
axis([0 0.7 -0.2 0.7]);  
xlabel('Risk: Std. Deviation');
ylabel('Expected Return');
title('Windows 7-9')
legend(legendInfo(7:9),'Location','NorthWest');
plot(RF_x(7:9,2), Opt1_y(7:9,2), '+r', 'MarkerSize', 10);
line(RF_x(7,:), Opt1_y(7,:));
line(RF_x(8,:), Opt1_y(8,:));
line(RF_x(9,:), Opt1_y(9,:));

subplot(2,2,4)
for i=10:11
    plot(std_p(i,:), mu_p(i,:))  %, 'color', ColorSet(i,:)
    hold on
    RF_x(i,:)   = [0 std_p(i, Index(i)) 2*std_p(i,Index(i))];
    Opt1_y(i,:) = [.01  mu_p(i,Index(i)) (2*mu_p(i,Index(i)) - 0.01) ];
    legendInfo{i} = ['Window' num2str(i)];
end
legend(legendInfo(10:11),'Location','NorthWest');
plot(RF_x(10:11,2), Opt1_y(10:11,2), '+r', 'MarkerSize', 10);
line(RF_x(10,:), Opt1_y(10,:));
line(RF_x(11,:), Opt1_y(11,:));
axis([0 0.7 -0.2 0.7]);  
xlabel('Risk: Std. Deviation');
ylabel('Expected Return');
title('Windows 10-11');