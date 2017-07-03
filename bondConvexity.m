function convexity = bondConvexity(numberOfPayments, coupon, period, timeToNextPayment, interestRate)
%This function evaluates dollar convexity of a bond. 
%numberOfPayments --- integer number of full future periods.
%cupon --- cash flow each period.
%period --- in the form (period / 1 year).
%timeToNextPayment --- in form NumberOf
%interestRate --- in form x/100.

    % forming the equation
    
    %taking into account that there is some time passed since last payment:
    C = timeToNextPayment * (timeToNextPayment + 1) * coupon * period * timeToNextPayment / ...
        (1 + interestRate * period) ^ timeToNextPayment;
    
    %loop with shifted time
    for i = 1:(numberOfPayments - 1)
        C = C + (timeToNextPayment + i) * (timeToNextPayment + (i + 1)) * coupon * period / ...
            (1 + interestRate * period) ^ (timeToNextPayment + i);
    end
    
    %Last payment. 100 --- principle payment
    C = C + (timeToNextPayment + numberOfPayments) * (timeToNextPayment + (numberOfPayments + 1)) * ...
        (100 + coupon * period) / (1 + interestRate * period) ^ (numberOfPayments + timeToNextPayment);

    %devide by 2 because of Tailor series and second derivative
    convexity = C / 2;
end