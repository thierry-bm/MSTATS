function V = optHedging(S,K,r,T,mu,sigma,put)
m = 2000;
[n,N] = size(S);
h = T/n;
beta = diag(exp(-r*linspace(0,T,n)));
S = beta*S;  
Delta = S(2:end,:) - S(1:end-1,:);
% R = log(S(2:end,:)./S(1:end-1,:));
% R = log(X(2:end,:)./X(1:end-1,:)) - h*r;

mean = h*(mu - r - sigma^2/2);
vol = sqrt(h)*sigma;
R = normrnd(mean,vol,10000,1);

minS = min(min(S));
maxS = max(max(S));
[x,C,a,c1,phi1] = Hedging_IID_MC2012(R,T,K,r,n,put,minS,maxS,m);

V = zeros(N,1);
V0 = interpolation_1d(S(1,1),C(1,:)',minS,maxS);
    
for i=1:N
    pi = V0;    % Matlab is such a bad language, you can redefine pi
    
    for k=1:n-1
        ak = interpolation_1d(S(k,i),a(k,:)',minS,maxS);
        phi = (ak - c1*pi)/S(k,i);
        pi = pi + phi*Delta(k,i);
    end
    
    V(i) = pi;
end
end