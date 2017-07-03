function duration = bondDuration(numberOfPayments, coupon, period, timeToNextPayment, interestRate)
%This function evaluates dollar duration of a bond.
%numberOfPayments --- integer number of full future periods.
%cupon --- cash flow each period.
%period --- in the form (period / 1 year).
%timeToNextPayment --- in form NumberOf
%interestRate --- in form x/100.
    
    % forming the D variable
    
    %taking into account that there is some time passed since last payment:
    D = timeToNextPayment * (coupon * period * timeToNextPayment) / (1 + interestRate * period) ^ timeToNextPayment;
    
    %loop with shifted time
    for i = 1:(numberOfPayments - 1)
        D = D + (i + timeToNextPayment) * coupon * period / (1 + interestRate * period) ^ (i + timeToNextPayment);
    end
    
    %Last payment. 100 --- principle payment
    D = D + (numberOfPayments + timeToNextPayment) * (100 + coupon * period) ...
        / (1 + interestRate * period) ^ (numberOfPayments + timeToNextPayment);

    duration = D;
end