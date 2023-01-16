%% objective function
% 1/mu*1^T*x-log(det(Fx))
% Fx = F0+sum_0^n xi*Fi
mu = 5; % initialize with large value
% def F
Q2=Q;
F0 = Q2; % from dual we konw F0 is just Q
for i = 1:n % use for loop and cell to create and restore Fi
    F_temp = zeros(m,n); % initial with zeros
    F_temp(i,i) = 1; % set (i,i) location of F to be 1
    F{i} = F_temp; % restore F in cell F
end

% initalize of v
v = ones(m,1)*1;

% objective function: -1/mu*1^T*x
Fx=F_cal(v);
obj = -sum(v);
%% find grad and hessian

grad=-ones(n,1);
F_isq=sqrtm(inv(Fx)); %This is F^(-1/2), which is the inverse of sqrt of F


% Hess = zeros(m,n);
% F_inv = inv(Fx);
% for i1=1:m
%     for i2=1:n
%         Hess(i1,i2) = trace(F_inv*F{i1}*F_inv*F{i2});
%     end
% end

%% update 
t = 1; % initial step ratio

iterations = 250;
vk = v;
step_newton = grad;
Q_diag=diag(F0);
for i3 = 1:iterations
    
    vk_next = vk+t*step_newton;
    Fx_next=F_cal(vk_next);

    Fx_next_PD=proj_PD(Fx_next);
    vk=Q_diag-diag(Fx_next_PD);


    t=t*0.99;
    if (mod(i3,10)==0)
        disp(num2str(i3/iterations*100)+"%")
    end
    obj_k(i3)=-sum(vk);
end


obj_k




function judge = is_PSD(X) % check if X is positive semi-definite
    d = eig(X); % find eigen value
    % do not need to check sysmetric here
    judge = all(d >= 0);
end

function X_PD=proj_PD(X)
    [V,D]=eig(X);
    D = D.*(D>=0);
    X_PD = V*D*inv(V);
end

function F_x = F_cal(x)
    n = evalin('base', 'n');
    F = evalin('base', 'F');
    F0 = evalin('base', 'F0');
    F_x = F0;
    for i = 1:n
        F_x = F_x + x(i)*F{i};
    end
end
