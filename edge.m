function [ME] = edge(epsi,R)
% calculate focusing 
% epsi in raddian
format long g;
%format short

ME = zeros(5,5);

ME(1,1)=1;
ME(2,2)=1;
ME(3,3)=1;
ME(4,4)=1;
ME(2,1)=tan(epsi)/R;
ME(4,3)=-tan(epsi)/R;
ME(5,5)=1;
