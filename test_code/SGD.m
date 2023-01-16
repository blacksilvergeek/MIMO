%% 
iteration_max = 50;
% [V,D]=eig(X_k);
gamma = 0.1;

X_k=diag(Q_diag/sum(Q_diag)*81);
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
record = [];

bar = waitbar(0,'Loading your data');
loopNum=5000;
a=(5*10^-4)^(1/loopNum);
for i=1:loopNum

   
    


    X_k_next = X_k-gamma*Q;
    for k=1:iteration_max
        X_k_next = DIAG_trans(X_k_next);
        [V,D]=eig(X_k_next);
        D = SD_trans(D);
        X_k_next = V*D*inv(V);
        
%         if i>=2 && norm(X_k_next-X_k)<0.01
%             break
%         end
    end
    
    X_k = real(X_k_next);
    gamma = a*gamma;
    record(i)=trace(Q*X_k);


    currentProgress = roundn((i/loopNum)*100,-1);
    barString = ['Current Progress:',num2str(currentProgress,'%.1f'),...
        '%,  Current min:',num2str(trace(Q*X_k)','%.2f')];
    waitbar(i/loopNum,bar,barString);
    

end
X_k_sign = X_k_next>0;
x_diff = X_k_next - X;
norm(x_diff)
trace(Q*X_k)


function  D_SD = SD_trans(D)
    D_SD=D.*(D>=0);
end

function  X_shaped = SD_trans_2(X)
    [V,D]=eig(X);
    D = D.*(D>=0.1)+0.1*diag(diag(D)<0.1);
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