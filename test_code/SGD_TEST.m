

gamma = 0.1;
loopNum = 10000;
a=(5*10^-3)^(1/loopNum);

bar = waitbar(0,'Loading your data');

gamma = 1/loopNum*5*10^-3;

gamma = 5*1e-9;
a=1;

iteration_max=1;

reducetimes=5;

for i=1:loopNum

    X_k_next = X_k-gamma*Q;

%     for k=1:iteration_max
%         
%         [V,D]=eig(X_k_next);
%         D = SD_trans(D);
%         X_k_next = V*D*inv(V);
%         X_k_next = DIAG_trans(X_k_next);
% %         if i>=2 && norm(X_k_next-X_k)<0.01
% %             break
% %         end
%     end
%     

        [V,D]=eig(X_k_next);
        D = SD_trans(D);
        X_k_next = V*D*inv(V);
        X_k_next = DIAG_trans(X_k_next);


    X_k = real(X_k_next);
%     gamma = a*gamma;
    record(i)=trace(Q*X_k);


    currentProgress = roundn((i/loopNum)*100,-1);
    barString = ['Current Progress:',num2str(currentProgress,'%.1f'),...
        '%,  Current min:',num2str(trace(Q*X_k)','%.4f')];
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