%Data of the bonds:

%%%% 1 %%%%
%https://screener.finance.yahoo.com/z2?ce=5715047147501516817356&q=b%3d1%26cpl%3d-1.000000%26cpu%3d-1.000000%26mtl%3d120%26mtu%3d-1%26pr%3d0%26rl%3d-1%26ru%3d-1%26sf%3dm%26so%3da%26stt%3d-%26yl%3d-1.000000%26ytl%3d-1.000000%26ytu%3d-1.000000%26yu%3d-1.000000

%CHICAGO ILL GO BDS
%Price:	107.90
%Coupon (%):	5.000
%Maturity Date:	1-Jan-2027
%Yield to Maturity (%):	4.161
%Current Yield (%):	4.634
%Fitch Ratings:	AA
%Coupon Payment Frequency:	Semi-Annual
%First Coupon Date:	1-Jan-2008
%Type:	Municipal


%%%% 2 %%%%
%https://screener.finance.yahoo.com/z2?ce=5714753149571515915950&q=b%3d1%26cpl%3d-1.000000%26cpu%3d-1.000000%26mtl%3d24%26mtu%3d36%26pr%3d0%26rl%3d-1%26ru%3d-1%26sf%3dm%26so%3da%26stt%3d-%26yl%3d-1.000000%26ytl%3d-1.000000%26ytu%3d-1.000000%26yu%3d-1.000000

%COCA COLA CO
%Price:	101.10
%Coupon (%):	1.650
%Maturity Date:	1-Nov-2018
%Yield to Maturity (%):	1.361
%Current Yield (%):	1.632
%Fitch Ratings:	AA
%Coupon Payment Frequency:	Semi-Annual
%First Coupon Date:	1-May-2014
%Type:	Corporate
%Callable:	No


%%%% 3 %%%%
%https://screener.finance.yahoo.com/z2?ce=5815548149511526015950&q=b%3d1%26cll%3d1%26cpl%3d-1.000000%26cpu%3d-1.000000%26mtl%3d-1%26mtu%3d-1%26pr%3d0%26rl%3d-1%26ru%3d-1%26sf%3dm%26so%3da%26stt%3d-%26yl%3d-1.000000%26ytl%3d1.000000%26ytu%3d-1.000000%26yu%3d-1.000000
%Callable

%ALPHABET HOLDING CO INC
%Price:	94.50
%Coupon (%):	7.750
%Maturity Date:	1-Nov-2017
%Yield to Maturity (%):	9.969
%Current Yield (%):	8.201
%Fitch Ratings:	CCC
%Coupon Payment Frequency:	Semi-Annual
%First Coupon Date:	1-Nov-2013
%Type:	Corporate
%Callable:	Yes


%%%% 4 %%%%
%https://screener.finance.yahoo.com/z2?ce=5615150145501725716249&q=b%3d1%26cpl%3d-1.000000%26cpu%3d1.000000%26mtl%3d24%26mtu%3d-1%26pr%3d1%26rl%3d-1%26ru%3d-1%26sf%3dm%26so%3da%26stt%3d-%26yl%3d-1.000000%26ytl%3d-1.000000%26ytu%3d-1.000000%26yu%3d-1.000000

%DISNEY WALT CO MTNS BE
%Price:	100.54
%Coupon (%):	0.537
%Maturity Date:	30-May-2019
%Yield to Maturity (%):	0.415
%Current Yield (%):	0.534
%Fitch Ratings:	A
%Coupon Payment Frequency:	Quarterly
%First Coupon Date:	30-Aug-2014
%Type:	Corporate
%Callable:	No


%%%% 5 %%%%
%https://screener.finance.yahoo.com/z2?ce=5015452146501555916447&q=b%3d1%26cpl%3d-1.000000%26cpu%3d2.000000%26mtl%3d24%26mtu%3d-1%26pr%3d1%26rl%3d-1%26ru%3d-1%26sf%3dm%26so%3da%26stt%3d-%26yl%3d-1.000000%26ytl%3d-1.000000%26ytu%3d-1.000000%26yu%3d-1.000000


%SHELL INTERNATIONAL FIN BV
%Price:	102.06
%Coupon (%):	2.000
%Maturity Date:	15-Nov-2018
%Yield to Maturity (%):	1.462
%Current Yield (%):	1.960
%Fitch Ratings:	AA
%Coupon Payment Frequency:	Semi-Annual
%First Coupon Date:	15-May-2014
%Type:	Corporate
%Callable:	No

%Clean price:
price = [107.90, 101.10, 94.50, 100.54, 102.06];

%time till next payment (in numberOfMonth/12):
timeToNextPayment = [1/12, 5/12, 5/12, 0, 0.5/12];

%Periods (in years)
period = [0.5, 0.5, 0.5, 0.25, 0.5];

% cupons in the form x/100 (annual)
coupon = [5.000/100, 1.650/100, 7.750/100, 0.537/100, 2.000/100];

% should be integer. Number of full future periods:
numberOfPayments = [20, 3, 1, 10, 3];



%% A %%

%Yield to Maturity
ytm = [0, 0, 0, 0, 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%
%bondYTM(price, numberOfPayments, coupon, period, timeToNextPayment)
%%%%%%%%%%%%%%%%%%%%%%%%%%
%Assign the values

% 1
bondYTM(price(1), numberOfPayments(1), coupon(1) * 100, period(1), timeToNextPayment(1));
ytm(1) = 0.04036;

% 2
bondYTM(price(2), numberOfPayments(2), coupon(2) * 100, period(2), timeToNextPayment(2));
ytm(2) = 0.00999;

% 3
bondYTM(price(3), numberOfPayments(3), coupon(3) * 100, period(3), timeToNextPayment(3));
ytm(3) = 0.1634;

% 4
bondYTM(price(4), numberOfPayments(4), coupon(4) * 100, period(4), timeToNextPayment(4));
ytm(4) = 0.0032;

% 5
bondYTM(price(5), numberOfPayments(5), coupon(5) * 100, period(5), timeToNextPayment(5));
ytm(5) = 0.00638;



%Duration

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%bondDuration(numberOfPayments, coupon, period, timeToNextPayment, interestRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
duration = [0, 0, 0, 0, 0];


for i = 1:5
    
    %assigning duaration
    duration(i) = bondDuration(numberOfPayments(i), coupon(i) * 100, period(i), timeToNextPayment(i), ytm(i)); 
end


%Convexity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%bondConvexity(numberOfPayments, coupon, period, timeToNextPayment, interestRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

convexity = [0, 0, 0, 0, 0];

for i = 1:5
    convexity(i) = bondConvexity(numberOfPayments(i), coupon(i) * 100, period(i), timeToNextPayment(i), ytm(i)); 
end



%% B %%

% amonunt of invested money in dollars (exchange rate for 30 November)
invest = 100000 * 1.0648

%Using linearity of a derivative
%Duration of the bond portfolio
D = 0;
for i = 1:5
    D = D + duration(i) * invest / price(i);
end

%Convexity of the bond portfolio
C = 0;
for i = 1:5
    C = C + convexity(i) * invest / price(i);
end


%% C %%
%increase of yield
deltaY = +0.015;

%change in price. 500 000 -- price of the portfolio
DeltaPrice = D * deltaY + C * deltaY ^ 2;