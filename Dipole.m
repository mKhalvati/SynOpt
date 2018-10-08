function [MDI] = Dipole(R,s,kef)
% calculate focusing Qpole matrices
format long g;
%format short
MDI = zeros(5,5);
%kef= abs(kef)
OMEG  = sqrt((1/(R^2))-kef);
SOMEG = s*OMEG;

eta   = ((1/R)-(kef*R))^-1;
ABK = sqrt(abs(kef));
OM = ABK*s;


MDI(1,1)=cos(SOMEG);
MDI(2,2)=cos(SOMEG);
MDI(1,2)=sin(SOMEG)/OMEG;
MDI(2,1)=-sin(SOMEG)*OMEG;
MDI(3,3)=cos(OM);
MDI(4,4)=cos(OM);
  if(kef==0.)
    MDI(3,4)=s;
  else
    MDI(3,4)=sin(OM)/ABK; 
  end
MDI(4,3)=-ABK*sin(OM);
MDI(5,5)=1;
MDI(1,5)=eta*(1-cos(SOMEG));
MDI(2,5)=(eta*OMEG)*sin(SOMEG);




