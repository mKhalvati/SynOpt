clc;
clear all;
format long g;
%format short 

DS=0.00001;

% Input section
Dev=zeros(8,6); % 1 for Type (1 Qpole Focusing, 2 Drift , 3 bending angle, 4 Dipole, 5 Qpole DeFocusing):
                % 2 for length : 3 for Keff : 4 for R of Dipole : 5 for Dipole angle

%Dipole difinition as Device 1
Dev(1,1) = 4;
Dev(1,2) = 1.5;
Dev(1,3) = 0;
Dev(1,4) = 3.8197;
Dev(1,5) = 0;

%QpoleF difinition as Device 1
Dev(2,1) = 1;
Dev(2,2) = 0.2;
Dev(2,3) = -1.2;
Dev(2,4) = 3.8197;
Dev(2,5) = 0;

%QpoleD difinition as Device 3
Dev(3,1) = 5;
Dev(3,2) = 0.4;
Dev(3,3) = +1.2;
Dev(3,4) = 3.8197;
Dev(3,5) = 0;

%Drift difinition as Device 4
Dev(4,1) = 2;
Dev(4,2) = 0.55;
Dev(4,3) = 0;
Dev(4,4) = 3.8197;
Dev(4,5) = 0;

%Angle difinition as Device 5
Dev(5,1) = 3;
Dev(5,2) = DS;
Dev(5,3) = 0;
Dev(5,4) = 3.8197;
Dev(5,5) = 0.1964;



%

setup   = [ Dev(2,1) Dev(4,1) Dev(5,1) Dev(1,1) Dev(5,1) Dev(4,1) Dev(3,1) Dev(4,1) Dev(5,1) Dev(1,1)  Dev(5,1) Dev(4,1) Dev(2,1) ] ;   
setupl  = [ Dev(2,2) Dev(4,2) Dev(5,2) Dev(1,2) Dev(5,2) Dev(4,2) Dev(3,2) Dev(4,2) Dev(5,2) Dev(1,2)  Dev(5,2) Dev(4,2) Dev(2,2) ] ;  
setupQf = [ Dev(2,3) Dev(4,3) Dev(5,3) Dev(1,3) Dev(5,3) Dev(4,3) Dev(3,3) Dev(4,3) Dev(5,3) Dev(1,3)  Dev(5,3) Dev(4,3) Dev(2,3) ] ;   
setupR  = [ Dev(2,4) Dev(4,4) Dev(5,4) Dev(1,4) Dev(5,4) Dev(4,4) Dev(3,4) Dev(4,4) Dev(5,4) Dev(1,4)  Dev(5,4) Dev(4,4) Dev(2,4) ] ;   
setupAng= [ Dev(2,5) Dev(4,5) Dev(5,5) Dev(1,5) Dev(5,5) Dev(4,5) Dev(3,5) Dev(4,5) Dev(5,5) Dev(1,5)  Dev(5,5) Dev(4,5) Dev(2,5) ] ;   







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
          Mnew=Dipole(his(j,3),DS); 
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
MTT;

'end matrices'

%initial optical value for x direction

bet0 = sqrt(-(MTT(1,2)*MTT(2,2))/(MTT(2,1)*MTT(1,1)));
alf0 = 0;
gam0 = 1/bet0;



%initial optical value for z direction
betz0 = sqrt(-(MTT(3,4)*MTT(4,4))/(MTT(4,3)*MTT(3,3)));
alfz0 = 0;
gamz0 = 1/betz0;



MB = zeros(5);
be = zeros(numel(his(:,1)),1);
al = zeros(numel(his(:,1)),1);
ga = zeros(numel(his(:,1)),1);
l = zeros(numel(his(:,1)),1);
be(1,1) =bet0 ;al(1,1) =alf0 ;ga(1,1) =gam0 ;

for j= 1:numel(his(:,1))
   if (his(j,1)==0)
      l(j,1)=0;
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
           Mnew=edge(his(j,4),his(j,3)); 
           l(j,1)=l(j-1,1)+0;
       end
       if (his(j,1)==4)
           Mnew=Dipole(his(j,3),DS);
           l(j,1)=l(j-1,1)+DS;
       end
       if (his(j,1)==5)
           Mnew=QpoleD(his(j,2),DS); 
           l(j,1)=l(j-1,1)+DS;
       end

      MB =Mnew;
      be(j) = ((MB(1,1)*MB(1,1))*be(j-1,1))-(2*MB(1,1)*MB(1,2)*al(j-1,1))+(MB(1,2)*MB(1,2)*ga(j-1,1));
      al(j) = (-MB(1,1)*MB(2,1)*be(j-1,1))+(((MB(1,1)*MB(2,2))+(MB(1,2)*MB(2,1)))*al(j-1,1))-(MB(2,2)*MB(1,2)*ga(j-1,1));
      ga(j) = ((MB(2,1)*MB(2,1))*be(j-1,1))-(2*MB(2,2)*MB(2,1)*al(j-1,1))+(MB(2,2)*MB(2,2)*ga(j-1,1));
    
  end
    
end

MB = zeros(5);
bez = zeros(numel(his(:,1)),1);
alz = zeros(numel(his(:,1)),1);
gaz = zeros(numel(his(:,1)),1);
lz = zeros(numel(his(:,1)),1);
bez(1,1) =betz0 ;alz(1,1) =alfz0 ;gaz(1,1) =gamz0 ;


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
            Mnew=edge(his(j,4),his(j,3)); 
            lz(j,1)=lz(j-1,1)+0;
        end
        if (his(j,1)==4)
            Mnew=Dipole(his(j,3),DS);
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
axis([0 6 0 12])

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

Qx = Qx *8
Qz = Qz *8

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

