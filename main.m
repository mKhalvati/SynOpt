clc;
clear all;
format long g;
%format short 
DS    = 0.001;
NS    = 4.;
Epart = 0.45;   % energy of particle in GeV

% Input section
Dev=zeros(8,6); % 1 for Type (1 Qpole Focusing, 2 Drift , 3 bending angle, 4 Dipole, 5 Qpole DeFocusing):
                % 2 for length : 3 for Keff : 4 for R of Dipole : 5 for Dipole angle
                
%Drift difinition as Device 4
Dev(1,1) = 2;
Dev(1,2) = 0.6524;
Dev(1,3) = 0;
Dev(1,4) = 0;
Dev(1,5) = 0;

Dev(2,1) = 2;
Dev(2,2) = 0.264;
Dev(2,3) = 0;
Dev(2,4) = 0;
Dev(2,5) = 0;

Dev(3,1) = 2;
Dev(3,2) = 0.337;
Dev(3,3) = 0;
Dev(3,4) = 0;
Dev(3,5) = 0;

Dev(4,1) = 2;
Dev(4,2) = 0.227;
Dev(4,3) = 0;
Dev(4,4) = 0;
Dev(4,5) = 0;


Dev(5,1) = 2;
Dev(5,2) = 0.11;
Dev(5,3) = 0;
Dev(5,4) = 0;
Dev(5,5) = 0;


Dev(6,1) = 2;
Dev(6,2) = 0.5424;
Dev(6,3) = 0;
Dev(6,4) = 0;
Dev(6,5) = 0;

%QpoleF difinition as Device 1
Dev(7,1) = 1;
Dev(7,2) = 0.166;
Dev(7,3) = 4.468250;
Dev(7,4) = 0;
Dev(7,5) = 0;

%QpoleD difinition as Device 3
Dev(8,1) = 5;
Dev(8,2) = 0.166;
Dev(8,3) = 2.062026;
Dev(8,4) = 0;
Dev(8,5) = 0;

%Dipole difinition as Device 1
angle    = 1.5708;
Dev(9,1) = 4;
Dev(9,2) = 1.5708;
Dev(9,3) = abs(-.50);
Dev(9,4) = Dev(9,2)/angle;
Dev(9,5) = 0;
R = Dev(9,4);
n=R*R*(Dev(9,3))

%Angle difinition as Device 5
Dev(10,1) = 3;
Dev(10,2) = DS;
Dev(10,3) = 0;
Dev(10,4) = R;
Dev(10,5) = 0.1964;

%Input of program [device line
DevLine = [ 1 7 2 8 3 9 4 5 8 2 7 5 6 ]
%End of input section

for j=1:numel(DevLine)
   setup(j)    =  Dev(DevLine(j),1);
   setupl(j)   =  Dev(DevLine(j),2);
   setupQf(j)  =  Dev(DevLine(j),3); 
   setupR(j)   =  Dev(DevLine(j),4);
   setupAng(j) =  Dev(DevLine(j),5);
end

BeamOptic(setup,setupl,setupQf,setupR,setupAng,DS,NS,Epart)

