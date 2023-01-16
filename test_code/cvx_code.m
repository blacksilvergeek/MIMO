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

% to simplify our program
% use x to denote our estimation of s


cvx_begin 
    variable X(m,n) symmetric semidefinite% transform to new variable X = x*x^T
    minimize(trace(Q*X)) % new objective function
    
    subject to
        diag(X) == 1;

cvx_end

%% calculate original x (get x from X=x*x^T)
% eigen decomposition
[V,D] = eig(X);

% sort for eigen value
[d,ind] = sort(diag(D),'descend');
Ds = D(ind,ind);
Vs = V(:,ind);

% generate original x
x_float = sqrt(Ds(1))*Vs(:,1);

% transform to 1 or -1 
% based on x_i>0 or not

x_predict = sign(x_float);
%% calculate error
% error in rounding x
resi_x = norm(x_float - x_predict)^2;
% error in objective function (or observation)
resi_obj = x_predict'*Q*x_predict;

% most import error !!!
% error our result x_predict to original sc

% transform x_predict from real back to complex vector x_complex
nhalf = floor(n/2);
x_r = x_predict(1:nhalf);
x_i = x_predict(nhalf+1:n-1);
x_complex = x_r+j*x_i;

resi_sc = norm(x_complex - sc);
%resi_sc = 1.9860e-15, can be regarded as zero

%% test G-W theorem
% assume the sc can achieve the lowest objective function value
%
min_val_BQP = norm(yc-Hc*sc)^2;
min_val_SDR = trace(Q*X);
% min_val_SDR = x_predict'*Q*x_predict;

disp("min of cvx: "+num2str(min_val_SDR))

disp("min value ratio: "+num2str(min_val_SDR/min_val_BQP))


%% another G-W method

% ther = 1e-4; 
% [U,R] = schur(X); 
% eig_value = diag(R); 
% rank_x = sum(eig_value>1e-4);
% 
% V = sqrt(diag(eig_value(eig_value>ther)))*U(eig_value>ther,:);
% 
% numTest = 10000;
% for nTest = 1:numTest
% %     x_hat = sign(diag(randn(n,rank_x)V));
%     x_hat = sign((randn(m,1)));
%     if nTest == 1
%         x_hat = x_predict;
%     end
%     result(:,nTest) =x_hat;
%     objval(nTest) = trace(Q*x_hat*x_hat');
%     % constranit_check(nTest) = mean(x_hat.^2);
% end
% [val,loc] = min(objval);
% val
% result(:,loc)

%% trying PGD
% 
% % initial value
% X0 = ones(m,n);
% 
% % create function handler
% obj = @func_obj;
% grad = @func_obj;
% 
% 
% % equality constraint
% Aeq = diag(ones(1,n));
% beq = diag(ones(1,n));
% GradientProjection(X0,obj,grad,Aeq,beq,Aeq,beq,1e-2,10,true)
% 
% 
% 
% % objective and gradient function definition
% function y = func_obj(X)
%     y = trace(Q*X);
% end
% 
% function y = func_grad(X)
%     % can be proved it's just transpose of Q
%     y = Q';
% end


% y_test=inv(Hc)*yc;
% y_test=sign(real(y_test))+j*sign(imag(y_test));
% sum(abs(y_test-sc)<1e-6)/40;

