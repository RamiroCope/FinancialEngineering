function [ port, opt_mu, opt_sigma ] = highest_slope_portfolio( R, RF, mu, sigma )
    % This function finds the portfolio with the largest slope
    % Here we use our defined correlation coefficient
    C=diag(sigma)*R*diag(sigma);

    A=2*C;
    A(:,end+1)=-(mu-RF);
    A(end+1,1:end-1)=(mu-RF)';

    Rp=mu(1);
    b=zeros(length(mu),1);
    b(end+1,1)=Rp-RF;

    x=inv(A)*b;
    xopt=x(1:length(mu))./sum(x(1:length(mu)))';

    % Return value
    port = xopt;
    opt_mu  = xopt' * mu;
    opt_sigma = sqrt( xopt' * C * xopt);

end

