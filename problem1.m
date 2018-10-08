clc

k=1
E  = 30e5;
w0 = 5e6;
e  = 1.6e-19;
vo = 2*pi*3000e6;

a = e*E/(w0*vo)
for j=0:0.01:2*pi   
    x(k)=1/(1+((a)*(1-sin(j))));
    z(k)=j;
    k=k+1;
end
hold on
plot(z,x,'b')
