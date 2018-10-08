function [MQF] = QpoleF(kf,s)
% calculate focusing Qpole matrices
format long g;
%format short

MQF = zeros(5,5);
ABK = sqrt(abs(kf));
OM = ABK*s;
MQF(1,1)=cos(OM);
MQF(2,2)=cos(OM);
MQF(3,3)=cosh(OM);
MQF(4,4)=cosh(OM);
MQF(1,2)=sin(OM)/ABK;
MQF(2,1)=-ABK*sin(OM);
MQF(3,4)=sinh(OM)/ABK;
MQF(4,3)=ABK*sinh(OM);
MQF(5,5)=1;
