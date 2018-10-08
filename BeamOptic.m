function [ME] = BeamOptic(setup,setupl,setupQf,setupR,setupAng,DS,NS,Epart)
% calculate BeamOptic for nominal particles focusing 
% epsi in raddian
format long g;
%format short

MTT = zeros(5);
Mnew = zeros(5);

% build lattice table (I called it History !)

k   = 1;
his(k,1) = 0;
his(k,2) = 0;
for j=1:numel(setup)
    for l=1:setupl(j)/DS
     k=k+1;   
     his(k,1)  = setup(j);
     his(k,2)  = setupQf(j);
     his(k,3)  = setupR(j);
     his(k,4)  = setupAng(j);
     his(k,4)  = setupR(j);
    end
end
k   = 1;


for j= 1:numel(his(:,1))
    if(j~=1)
%------------------------------------------------       
        if (his(j,1)==1)
           Mnew=QpoleF(his(j,2),DS);
        end
        
        if (his(j,1)==2)
           Mnew=Drift(DS); 
        end
        
        if (his(j,1)==3)
           Mnew=edge(his(j,4),his(j,3)); 
        end
        
        if (his(j,1)==4)
            Mnew=Dipole(his(j,3),DS,his(j,2)); 
        end
        
        if (his(j,1)==5)
           Mnew=QpoleD(his(j,2),DS); 
        end
        if (j==2)
           MTT = Mnew;
        else
           MTT =Mnew*MTT;
        end 
%------------------------------------------------        
   end    
end

%'end matrices'

MTT
%CHECK STABILITY  CONDITIONS FOR EXICTING OF BETA FUNCTIONS
stx=MTT(1,2)/MTT(2,1);
stz=MTT(3,4)/MTT(4,3);
if((stx<0)&&(stz<0))

%initial value of dispersion functions
des0 = -MTT(2,5)/MTT(2,1)
des1 = -((MTT(1,1)*MTT(2,5))/MTT(2,1))+MTT(1,5)

%initial optical value for x direction
bet0 = sqrt(-(MTT(1,2)*MTT(2,2))/(MTT(2,1)*MTT(1,1)));
alf0 = 0;
gam0 = 1/bet0;



%initial optical value for z direction
betz0 = abs(sqrt(-(MTT(3,4)*MTT(4,4))/(MTT(4,3)*MTT(3,3))));
alfz0 = 0;
gamz0 = 1/betz0;

MB      = zeros(5);
be      = zeros(numel(his(:,1)),1);
Dif     = be;
Difp    = Dif;
al      = zeros(numel(his(:,1)),1);
ga      = zeros(numel(his(:,1)),1);
l       = zeros(numel(his(:,1)),1);
Hint    = zeros(numel(his(:,1)),1);
I1      = zeros(numel(his(:,1)),1);
I2      = zeros(numel(his(:,1)),1);
I3      = zeros(numel(his(:,1)),1);
I4      = zeros(numel(his(:,1)),1);
I5      = zeros(numel(his(:,1)),1);
be(1,1) = bet0;
al(1,1) = alf0;
ga(1,1) = gam0 ;

for j= 1:numel(his(:,1))
   if (his(j,1)==0)
      l(j,1)=0;
   end    
   if (j==1)
      Dif(1)  = des0;
      Difp(1) = 0.;
   end   
    if(j~=1)
       if (his(j,1)==1)
           Mnew=QpoleF(his(j,2),DS); 
           l(j,1)=l(j-1,1)+DS;
       end
       if (his(j,1)==2)
           Mnew=Drift(DS); 
           l(j,1)=l(j-1,1)+DS;
       end   
       if (his(j,1)==3)
           Mnew=edge(his(j,4),his(j,5)); 
           l(j,1)=l(j-1,1)+0;
       end
       if (his(j,1)==4)
           Mnew=Dipole(his(j,3),DS,his(j,2));
           l(j,1)=l(j-1,1)+DS;
       end
       if (his(j,1)==5)
           Mnew=QpoleD(his(j,2),DS); 
           l(j,1)=l(j-1,1)+DS;
       end

      MB     =  Mnew;
      be(j)  = ((MB(1,1)*MB(1,1))*be(j-1,1))-(2*MB(1,1)*MB(1,2)*al(j-1,1))+(MB(1,2)*MB(1,2)*ga(j-1,1));
      al(j)  = (-MB(1,1)*MB(2,1)*be(j-1,1))+(((MB(1,1)*MB(2,2))+(MB(1,2)*MB(2,1)))*al(j-1,1))-(MB(2,2)*MB(1,2)*ga(j-1,1));
      ga(j)  = ((MB(2,1)*MB(2,1))*be(j-1,1))-(2*MB(2,2)*MB(2,1)*al(j-1,1))+(MB(2,2)*MB(2,2)*ga(j-1,1));
      Dif(j) = (MB(1,1)*Dif(j-1))+(MB(1,2)*Difp(j-1))+(MB(1,5));
      Difp(j)= (MB(2,1)*Dif(j-1))+(MB(2,2)*Difp(j-1))+(MB(2,5));
      
      
       if (his(j,1)==4)
           Hint(j)  =  (ga(j)*(Dif(j)^2))+(2*al(j)*Dif(j)*Difp(j))+(be(j)*(Difp(j)^2))/(his(j,3)^3.);
           I1(j)    =  (Dif(j)/his(j,3));
           I2(j)    =  (1/(his(j,3)^2.));
           I3(j)    =  (1/(his(j,3)^3.));
           neff     =   his(j,3)*his(j,3)*his(j,2);
           I4(j)    =  (((1-(2*neff))*Dif(j))/(his(j,3)^3.));
           I5(j)    =  (Hint(j)/(his(j,3)^3.));
       else
           Hint(j)  =  0;
           I1(j)    =  0;
           I2(j)    =  0;
           I3(j)    =  0;
           I4(j)    =  0;
           I5(j)    =  0;
       end    
  end
    
end

celLen    =  l(numel(his(:,1)));
emit = emittance(Epart,celLen,l,I1,I2,I3,I4,I5,NS);
emit'


MB        = zeros(5);
bez       = zeros(numel(his(:,1)),1);
alz       = zeros(numel(his(:,1)),1);
gaz       = zeros(numel(his(:,1)),1);
lz        = zeros(numel(his(:,1)),1);
bez(1,1)  = betz0 ;alz(1,1) =alfz0 ;gaz(1,1) =gamz0 ;


for j= 1:numel(his(:,1))
   if (his(j,1)==0)
      lz(j,1)=0;
   end
    if(j~=1)
        if (his(j,1)==1)
            Mnew=QpoleF(his(j,2),DS); 
            lz(j,1)=lz(j-1,1)+DS;
        end
        if (his(j,1)==2)
            Mnew=Drift(DS); 
            lz(j,1)=lz(j-1,1)+DS;
        end   
        if (his(j,1)==3)
            Mnew=edge(his(j,4),his(j,5)); 
            lz(j,1)=lz(j-1,1)+0;
        end
        if (his(j,1)==4)
            Mnew=Dipole(his(j,3),DS,his(j,2));
            lz(j,1)=lz(j-1,1)+DS;
        end
        if (his(j,1)==5)
            Mnew=QpoleD(his(j,2),DS); 
            lz(j,1)=lz(j-1,1)+DS;
        end

             MB =Mnew;
             bez(j) =((MB(3,3)*MB(3,3))*bez(j-1,1))-(2*MB(3,3)*MB(3,4)*alz(j-1,1))+(MB(3,4)*MB(3,4)*gaz(j-1,1));
             alz(j) =(-MB(3,3)*MB(4,3)*bez(j-1,1))+(((MB(3,3)*MB(4,4))+(MB(3,4)*MB(4,3)))*alz(j-1,1))-(MB(4,4)*MB(3,4)*gaz(j-1,1));
             gaz(j) =((MB(4,3)*MB(4,3))*bez(j-1,1))-(2*MB(4,4)*MB(4,3)*alz(j-1,1))+(MB(4,4)*MB(4,4)*gaz(j-1,1));
      
    end
  
end

figure;
grid on;
hold on;
plot(l,be,'LineWidth',2)
hold on;
plot(lz, bez,'r','LineWidth',2)
hold on;
plot(l,Dif*10,'g','LineWidth',2)
%hold on;
%plot(l,Difp*10,'black','LineWidth',2)
axis([0 5 -2 14])

figure;
grid on
hold on;
plot(l,al,'LineWidth',2)
hold on;
plot(lz, alz,'r','LineWidth',2)
%axis([0 6 -3 3])

figure
grid on
hold on;
plot(l,ga,'LineWidth',2)
hold on;
plot(lz, gaz,'r','LineWidth',2)
%axis([0 6 0 1])

for j=1:numel(his(:,1))
   beb(j)=1./be(j); 
   bezb(j)=1./bez(j);
end
Qx = trapz(lz,beb)/(2*pi);
Qz = trapz(lz,bezb)/(2*pi);

Qx = Qx *NS
Qz = Qz *NS

lzz =lz;
lzz= lzz';
for j=2:numel(his(:,1))
   epsx(j)=trapz(lzz(1:j),beb(1:j));
   epsz(j)=trapz(lzz(1:j),bezb(1:j));   
end

  %plot(Qx,Qz,'ro','LineWidth',3)
  bep= zeros(numel(his(:,1)),1);
  alp= zeros(numel(his(:,1)),1);
  gap= zeros(numel(his(:,1)),1);
  
  
  bezp= zeros(numel(his(:,1)),1);
  alzp= zeros(numel(his(:,1)),1);
  gazp= zeros(numel(his(:,1)),1);
  
  
  for j= 1:numel(his(:,1))
   if (his(j,1)==0)
      l(j,1)=0;
   end
    if(j~=1)
    KS = 0;
    if (his(j,1)==1)
      KS = -his(j,2);
    end
    
    %QD
   if (his(j,1)==5)
      KS = -his(j,2); 
   end
   
   %Dipole
   if (his(j,1)==4)
      KS = 1/his(j,3); 
   end
   
   
   
   bep(j) = -2*al(j);
   alp(j) = be(j)*KS -ga(j);
   gap(j) = 2*al(j)*KS;
    
   bezp(j) = -2*alz(j);
   alzp(j) = bez(j)*KS -gaz(j);
   gazp(j) = 2*alz(j)*KS;
   
  end
  end

  
figure;
grid on
hold on;
plot(l,alp,'LineWidth',2)
hold on;
plot(lz, alzp,'r','LineWidth',2)
%axis([0 6 -3 3])

figure;
grid on
hold on;
plot(l,bep,'LineWidth',2)
hold on;
plot(lz, bezp,'r','LineWidth',2)
%axis([0 6 -3 3])

figure;
grid on
hold on;
plot(l,ga,'LineWidth',2)
hold on;
plot(lz, gazp,'r','LineWidth',2)
%axis([0 6 -3 3])

figure;
grid on
hold on;
plot(lz,epsx,'LineWidth',2)
hold on;
plot(lz, epsz,'r','LineWidth',2)
%axis([0 6 -3 3])



else
    'this data havent any stable solutions'
    
end