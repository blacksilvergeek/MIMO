clear;
clc;
load('mimo_detection.mat');
% convert the complex-value discrete least squares problem into 
% real-value homogeneous QCQP.
y = [real(yc);imag(yc)];
H = [real(Hc),-imag(Hc);imag(Hc),real(Hc)];
C = [H.'*H,-H.'*y;-y.'*H,y.'*y];
% Implement a low-complexity algorithm-subgradient
% Initialize variables
k=0;                   % Iteration step
tol=0.1;               % Tolerance
alpha=0.01;             % Step size alpha
S0=0;

% While the stopping criterion is not met
while true&&(k<10)
    disp(k)
% Calculate the gradient of the objective function
%Update the decision variables by taking a step in the negative gradient direction
g=f(S0,y,H);
disp(k)
S=S0-alpha*g;
S0 = sign(S);
% Increase the iteration counter
k=k+1;
% Check the tolerance
if norm(g)<tol
    break;
end
end
% %% % recovered signal vector
% SC = sc_(1:end/2)+sc_(end/2+1:end)*sqrt(-1); % recovered signal vector
% % [number,ratio] = symerr(SC,sc);
% error = norm((sc-SC));
% error_detail = sc-SC;

function [z,grad,g]=f(S0,y,H)
syms S;
z=(y-H*S).'*(y-H*S);
grad=diff(z);
g=subs(grad,S,S0);
end