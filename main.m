%% install cvx
% addpath(genpath('cvx'))
% cvx_setup

%% generate variable for BQP
importfile("mimo_detection")

% real part and imaginary part of Hc, yc
Hc_r = real(Hc);
Hc_i = imag(Hc);
yc_r = real(yc);
yc_i = imag(yc);


% adding dimensions to convert complex number problem to real number
% correspnding H and y for real number problem
H = [Hc_r -Hc_i;
    Hc_i Hc_r];
y = [yc_r;yc_i];

% Quadratic form matrix for BQP problem
Q = [H'*H, -H'*y;
    -y'*H, y'*y];

[m, n] = size(Q);
%% use cvx

% Abandoned solution but useful to see deduction
% cvx_begin
%     variable x(n)
%     minimize(x'*Q*x)
%     subject to
%         abs(x)=1
% x
% cvx_end

cvx_begin SDP
    variable X(m,n) symmetric % transform to new variable X = x*x^T
    minimize(trace(Q*X)) % new objective function
    
    subject to
    % loop for contrain the x_i square is 1
    for i = 1:n
        X(i,i) == 1;
    end
    % in SDP field, this is semi-definite condition
    X>=0;
cvx_end

%% calculate original x
[V,D] = eig(X);
% sort for eigen value
[d,ind] = sort(diag(D),'descend');
Ds = D(ind,ind);
Vs = V(:,ind);

% generate original x
x_float = sqrt(Ds(1))*Vs(:,1);
% transform to 1 or -1 
% based on x_i>0 or not
x_predict = (x_float>0)+(-1)*(x_float<=0);


%% calculate error
% error in rounding x
resi_x = norm(x_float - x_predict)^2
% error in objective function (or observation)
resi_obj = x_predict'*Q*x_predict

% most import error !!!
% error our result x_predict to original sc

% transform x_predict back to complex vector x_complex
nhalf = floor(n/2)
x_r = x_predict(1:nhalf);
x_i = x_predict(nhalf+1:n-1);
x_complex = x_r+j*x_i

resi_sc = norm(x_complex - sc) 
%resi_sc = 1.9860e-15, can be regarded as zero

%%









