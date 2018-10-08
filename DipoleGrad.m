function [MDI] = DipoleGrad(R,s,keff)
% calculate focusing Qpole matrices
format long g;
%format short

MDI = zeros(5,5);

OM = sqrt((1/(R^2))-keff)
MDI(1,1)=cos(OM*s);
MDI(2,2)=cos(OM*s);
MDI(3,3)=cosh(OM*s);
MDI(4,4)=cosh(OM*s);
MDI(1,2)=sin(OM*s)*OM;
MDI(2,1)=-sin(OM*s)/OM;
MDI(3,4)=sinh(OM*s)/OM;
MDI(5,5)=sin(OM*s)*OM;
MDI(1,5)=R*(1-cos(OM*s));
MDI(2,5)=sin(OM*s);
