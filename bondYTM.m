function yieldToMaturity = bondYTM(price, numberOfPayments, coupon, period, timeToNextPayment)
%This function evaluates yeild to maturity of a bond. 
%Price --- just clean price
%Cupon --- cash flow each year
%numberOfPayments --- integer number.
%period --- in form period/year
%timeToNextPayment --- in the form (number of month)/12

%Return --- annualized YTM
    
    
    % forming the equation
    syms y;
    
    %first term makes price ditry
    exp = (coupon * period * timeToNextPayment) / (1 + period * y) ^ (timeToNextPayment);
    
    
    for i = 1:(numberOfPayments - 1)
        % time shifted
        exp = exp + (coupon * period) / (1 + period * y) ^ (timeToNextPayment + i)
    end
    
    %Last payment. 100 --- principle payment
    exp = exp + (100 + coupon * period) / (1 + period * y) ^ (timeToNextPayment + numberOfPayments);
    
    %Solving the equation
    equation = (exp == price);
    yieldToMaturity = vpasolve(equation)
end