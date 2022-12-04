%% generate variable for BQP

% real part and imaginary part of Hc, yc
Hc_r = real(Hc);
Hc_i = imag(Hc);
yc_r = real(yc);
yc_i = imag(yc);

importfile("mimo_detection")
% adding dimensions to convert complex number problem to real number
% correspnding H for real number problem
H = [Hc_r -Hc_i;
    Hc_i Hc_r];
y = [yc_r;yc_i];

% Quadratic form matrix for BQP problem
Q = [H'*H, -H'*y;
    -y'*H, y'*y];

[m, n] = size(Q);
%% use cvx 

% cvx_begin
%     variable x(n)
%     minimize(x'*Q*x)
% %     minimize((x-1)'*(x-1)+x'*Q*x)
% %     minimize((x+1)'*(x+1)+x'*Q*x)
% %     minimize(abs(x'*x-1)+x'*Q*x)
%     subject to
%         abs(x)>=1
% x
% cvx_end

cvx_begin SDP
    variable x(m,n) symmetric
    minimize(trace(Q*x))
%     minimize((x-1)'*(x-1)+x'*Q*x)
%     minimize((x+1)'*(x+1)+x'*Q*x)
%     minimize(abs(x'*x-1)+x'*Q*x)
    subject to
        trace(x)==1
        x>=0
x
cvx_end


% give up need commerical or academic version

%% use yalmip

% x = binvar(n,1);









