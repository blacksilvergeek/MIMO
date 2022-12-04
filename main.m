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
variable X(m,n) symmetric
minimize(trace(Q*X))

subject to
for i = 1:n
    X(i,i) == 1;
end
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
x = (x_float>0)+(-1)*(x_float<=0)
resi = norm(x_float - x)

%%









