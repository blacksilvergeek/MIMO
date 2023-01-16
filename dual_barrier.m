
%% 
iteration_max = 10;
% [V,D]=eig(X_k);
gamma = 0.1;
a=1;
Q_diag=diag(Q);
X_k=diag(Q_diag/sum(Q_diag)*81);
% X_k=zeros(81);
% X_k(1,1)=27;
X_k_next = (X_k);

% X_k_next = X_k;
% for i=1:iteration_max
%     if i>=2 && norm(X_k_next-X_k)<0.01
%         break
%     end
%     X_k_next = DIAG_trans(X_k);
%     [V,D]=eig(X_k);
%     D = SD_trans(D);
%     X_k = V*D*inv(V);
% end
eig_k=0.8;

record=[];
record_test=[];
for i=1:10000
    X_half=sqrtm(X_k);
    judge_reform=inv(X_half)*Q*inv(X_half);
    gamma=1/max(real(eig(judge_reform)));
    %     eig(X_k-gamma*Q);
    
    X_k_next = X_k-gamma*Q;


    X_k_next = DIAG_trans(X_k_next);

% %     trace(Q*X_k_next)
%     record_test(i) = trace(Q*X_k_next);
% %     X_k_next = DIAG_trans(X_k_next);
%     for k=1:iteration_max
%         X_k_next = DIAG_trans(X_k_next);
%         [V,D]=eig(X_k_next);
% 
%         D = SD_trans(D);
%         X_k_next = V*D*inv(V);
% %         if i>=2 && norm(X_k_next-X_k)<0.01
% %             break
% %         end
%     end

    X_k = real(X_k_next);
    X_k=SD_trans_2(X_k);
    
    record(i)=trace(Q*X_k);
%     gamma = a*gamma;
    eig_k=eig_k*a;
    if mod(i,1000)==0
        eig_k=0.8*eig_k;
    end
end

%%



% X_k_sign = X_k_next>0;
% x_diff = X_k_next - X;
% norm(x_diff)
eig(X_k)'
trace(Q*X_k)
function  D_SD = SD_trans(D)
    eig_k=evalin('base', 'eig_k');
    D_SD=D.*(D>=0);
end

function  X_shaped = SD_trans_2(X)
    eig_k=evalin('base', 'eig_k');
    [V,D]=eig(X);
    
    D = D.*(D>=eig_k)+eig_k*diag(diag(D)<eig_k);
    X_shaped = V*D*inv(V);
    
end

function X_DIAG = DIAG_trans(X)
    X0=X;
    [m,n]=size(X0);
    for i=1:m
        X0(i,i)=1;
    end
    X_DIAG = X0;
end

%%some results
% i1    i2      a       obj
% 1000  100     0.99    49

% A = magic(5)
% [V,D]=eig(A);
% V*D*inv(V)