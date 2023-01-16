cvx_begin 
    variable X(m,n) symmetric semidefinite% transform to new variable X = x*x^T
    minimize(trace(Q*X)) % new objective function
    
    subject to
        diag(X) == 1;

cvx_end