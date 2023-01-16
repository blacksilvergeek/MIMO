%% objective function
% 1/mu*1^T*x-log(det(Fx))
% Fx = F0+sum_0^n xi*Fi
mu = 0; % initialize with large value
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

% objective function: 1/mu*1^T*x-log(det(Fx))
Fx=F_cal(v);
obj = -mu*sum(v)-log(prod(eig(F0)));
%% find grad and hessian

grad=zeros(n,1);
F_isq=sqrtm(inv(Fx)); %This is F^(-1/2), which is the inverse of sqrt of F
for i=1:n
    grad(i) = -mu-trace(F_isq*F{i}*F_isq);
end

Hess = zeros(m,n);
F_inv = inv(Fx);
for i1=1:m
    for i2=1:n
        Hess(i1,i2) = trace(F_inv*F{i1}*F_inv*F{i2});
    end
end

%% update 
t = 1; % initial step ratio

iterations = 300;
iterations_last = 250;
iterations_first = 20;
vk = v;
mu0 = 200;
step_mu = mu0/(iterations_last-iterations_first)*5;
for i3 = 1:iterations
    step_newton = inv(Hess)*grad;
    vk_next = vk+t*step_newton;
    Fx_next=F_cal(vk_next);


    if ~is_PSD(Fx_next)
        t = 0.8*t;
    else
        vk = real(vk_next);
        grad=zeros(n,1);
        Fx = real(Fx_next);
        F_isq=sqrtm(inv(Fx)); %This is F^(-1/2), which is the inverse of sqrt of F
        for i=1:n
            grad(i) = -mu-trace(F_isq*F{i}*F_isq);
        end
        
        Hess = zeros(m,n);
        F_inv = inv(Fx);
        for i1=1:m
            for i2=1:n
                Hess(i1,i2) = trace(F_inv*F{i1}*F_inv*F{i2});
            end
        end

%         if 100<i3<150
%             mu=1.2*mu;
%         end
%         if 150<i3<200
%             mu=1.2*mu;
%         end
    end
    if i3==iterations_first+1
        t = 0.5;
    elseif mod(i3,5)==0 && i3<=iterations_last
        mu=mu+step_mu;
    elseif i3==iterations_last+1
        t=0.5;
    end
    
    obj_k(i3)=-mu*sum(vk)-log(prod(eig(Fx)));
    disp(i3)
end

obj
obj_k
obj_k-log(prod(eig(Fx)))
obj_k(i3)/mu
% obj_k = sum(vk)+mu*log(det(Fx))


function judge = is_PSD(X) % check if X is positive semi-definite
    d = eig(X); % find eigen value
    % do not need to check sysmetric here
    judge = all(d >= 0);
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
