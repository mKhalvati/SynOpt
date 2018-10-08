function [MDR] = Drift(s)
% calculate focusing Qpole matrices
format long g;
%format short

MDR = zeros(5,5);

MDR(1,1)=1;
MDR(2,2)=1;
MDR(3,3)=1;
MDR(4,4)=1;
MDR(1,2)=s;
MDR(3,4)=s;
MDR(5,5)=1;
