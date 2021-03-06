function AA = triform4(p,p1,t,t1,UU,S,MM,nu,lambda,g_beta,linear)
% Diffusion and convection term for Taylor-Hood element
% together with buoyancy term for temperature
N1 = size(p,2); N2 = size(p1,2); N = N1 + N2; NULL = sparse(N,N); 
CC11 = sparse(N,N); CC12 = CC11; CC21 = CC11; CC22 = CC11;
CC31 = CC11; CC32 = CC11;
U = UU(1:N); V = UU(N+1:2*N); TT = UU(2*N+1:3*N);
switch linear
case 0
for I = 1:size(t,2)
   J = t(1:3,I); K = t1(:,I); L = [J;K];
   XK = p(1,J); YK = p(2,J); UK = U(L); VK = V(L); TK = TT(L);
   [AU,BU,AV,BV,AT,BT] = triform3_aux(XK,YK,UK,VK,TK);
   CC11(L,L) = CC11(L,L) + AU;
   CC12(L,L) = CC12(L,L) + BU;
   CC21(L,L) = CC21(L,L) + AV;
   CC22(L,L) = CC22(L,L) + BV;
   CC31(L,L) = CC31(L,L) + AT;
   CC32(L,L) = CC32(L,L) + BT;

end
% the operator without terms for pressure P
AA = [CC11 + nu*S, CC12,         NULL;
      CC21,        CC22 + nu*S, -g_beta*MM;
      CC31,        CC32,         lambda*S];
case 1      
AA = [nu*S, NULL,          NULL;
     NULL, nu*S,    -g_beta*MM;
     NULL, NULL,      lambda*S];
end  
AA = sparse(AA);