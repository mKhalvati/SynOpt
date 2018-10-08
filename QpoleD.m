function [MQD] = QpoleD(kd,s)
% calculate focusing Qpole matrices
format long g;
%format short

MQD = zeros(5,5);
ABK = sqrt(abs(kd));
OM = ABK*s;
MQD(1,1)=cosh(OM);
MQD(2,2)=cosh(OM);
MQD(3,3)=cos(OM);
MQD(4,4)=cos(OM);
MQD(1,2)=sinh(OM)/ABK;
MQD(2,1)=ABK*sinh(OM);
MQD(3,4)=sin(OM)/ABK;
MQD(4,3)=-ABK*sin(OM);
MQD(5,5)=1;